require "parslet"

module Veritas
  module TD
    class Parser < Parslet::Parser
      # Whitespace
      rule(:wsp)  { match('\s').repeat(1) }
      rule(:wsp?) { wsp.maybe }

      # No-ops
      rule(:noop) { wsp.as(:noop) }

      # Integers
      rule(:int) { match["0-9"].repeat(1).as(:int) }

      # Strings
      rule(:escaped_char) { (str("\\") >> any).as(:escaped_char) }
      rule(:sq_str_chars) { match["^'\\\\"].repeat(1).as(:chars) }
      rule(:sq_str_body)  { (escaped_char | sq_str_chars).repeat }
      rule(:sq_str)       { str("'") >> sq_str_body >> str("'") }
      rule(:dq_str_chars) { match['^"\\\\'].repeat(1).as(:chars) }
      rule(:dq_str_body)  { (escaped_char | dq_str_chars).repeat }
      rule(:dq_str)       { str('"') >> dq_str_body >> str('"') }
      rule(:string)       { (sq_str | dq_str).as(:string) }

      rule(:bool_true)    { ci_str("TRUE").as(:true) }
      rule(:bool_false)   { ci_str("FALSE").as(:false) }
      rule(:boolean)      { bool_true | bool_false }

      # Scalar types
      rule(:scalar) { int | string | boolean }

      # Unary expressions
      rule(:unary_op)   { padded(str("-").as(:minus) | str("+").as(:plus)) }
      rule(:unary_expr) { unary_op >> int.as(:value) }

      # Binary expressions
      rule(:sum)         { (operand.as(:left) >> padded("+") >> expr.as(:right)).as(:sum) }
      rule(:subtract)    { (operand.as(:left) >> padded("-") >> expr.as(:right)).as(:subtract) }
      rule(:multiply)    { (operand.as(:left) >> padded("*") >> expr.as(:right)).as(:multiply) }
      rule(:divide)      { (operand.as(:left) >> padded("/") >> expr.as(:right)).as(:divide) }
      rule(:operand)     { scalar }
#      rule(:operand)     { scalar | expr } # FIXME: This rule is what is causing 'Stack level too deep', but without such a rule, expressions can't be infinitely nested
      rule(:binary_expr) { multiply | divide | sum | subtract }

      # Relations
      rule(:table_dee) { ci_str("TABLE_DEE").as(:table_dee) }
      rule(:table_dum) { ci_str("TABLE_DUM").as(:table_dum) }
      rule(:relation)  do
        (ci_str("RELATION") >> padded("{") >> tuple_list >> padded("}")).as(:relation) |
          table_dee |
          table_dum
      end

      # Identifiers
      rule(:identifier) { match["A-Za-z_"] >> match["a-zA-Z0-9_"].repeat }

      # Attributes
      rule(:attribute_ref) { (identifier).as(:attribute_ref) }

      # Tuples
      rule(:tuple)                { (ci_str("TUPLE") >> padded("{") >> tuple_component_list >>  padded("}")).as(:tuple) }
      rule(:tuple_component)      { attribute_ref.as(:name) >> wsp >> expr.as(:value) }
      rule(:tuple_component_list) { tuple_component.repeat(0, 1) >> (padded(",") >> tuple_component).repeat }
      rule(:tuple_list)           { tuple.repeat(0, 1) >> (padded(",") >> tuple).repeat }

      # Operations
      rule(:join_operation) { (relation.as(:left) >> padded(ci_str("JOIN")) >> relation.as(:right)).as(:join) }
      rule(:operation)      { join_operation }

      rule(:variable) { identifier.as(:variable) }

      # Complex expressions
      rule(:expr) { padded(parenthesized(expr) | operation | relation | unary_expr | binary_expr | scalar | variable) }

      # Full user input (currently single expressions only)
      rule(:prog) { expr | noop }

      # Top-level element is any possible expression
      root(:prog)

      # The parse method is overloaded to transform the tree and left-associate
      # branches that are incorrectly right-associated by default
      #
      # Note that Parslet does not support left-associative grammars
      def parse(input)
        reassociate(super)
      end

      private

      def ci_str(s)
        Atoms::CaseInsensitiveStr.new(s)
      end

      def padded(other)
        other = str(other) unless Parslet::Atoms::Base === other
        wsp? >> other >> wsp?
      end

      def parenthesized(other)
        (padded("(") >> other >> padded(")")).as(:parenthesized)
      end

      def reassociate(tree)
        @associativity ||= Associativity.new
        @associativity.apply(tree)
      end
    end
  end
end
