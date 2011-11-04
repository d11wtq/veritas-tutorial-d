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

      # Scalar types
      rule(:scalar) { int | string }

      # Unary expressions
      rule(:unary_op)   { padded(str("-").as(:minus) | str("+").as(:plus)) }
      rule(:unary_expr) { unary_op >> int.as(:value) }

      # Binary expressions
      rule(:sum)         { (operand.as(:left) >> padded("+") >> expr.as(:right)).as(:sum) }
      rule(:subtract)    { (operand.as(:left) >> padded("-") >> expr.as(:right)).as(:subtract) }
      rule(:multiply)    { (operand.as(:left) >> padded("*") >> expr.as(:right)).as(:multiply) }
      rule(:divide)      { (operand.as(:left) >> padded("/") >> expr.as(:right)).as(:divide) }
      rule(:binary_expr) { multiply | divide | sum | subtract }
      rule(:operand)     { scalar | expr }

      # Relations
      rule(:table_dee) { ci_str("TABLE_DEE").as(:table_dee) }
      rule(:table_dum) { ci_str("TABLE_DUM").as(:table_dum) }
      rule(:relation)  do
        (ci_str("RELATION") >> padded("{") >> tuple.repeat >> padded("}")).as(:relation) |
          table_dee |
          table_dum
      end

      # Tuples
      rule(:tuple) { (ci_str("TUPLE") >> padded("{") >> padded("}")).as(:tuple) }

      # Complex expressions
      rule(:expr) { parenthesized(expr) | padded(unary_expr | binary_expr | scalar) }

      # Full user input (currently single expressions only)
      rule(:prog) { noop | relation | expr }

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
