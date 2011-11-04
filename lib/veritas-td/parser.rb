require "parslet"

module Veritas
  module TD
    class Parser < Parslet::Parser
      # Whitespace
      rule(:wsp)  { match('\s').repeat }
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

      # Unary Expressions
      rule(:unary_op)   { padded(str("-").as(:minus) | str("+").as(:plus)) }
      rule(:unary_expr) { unary_op >> int.as(:value) }

      # Complex expressions
      rule(:expr) { padded(unary_expr | int | string) }

      rule(:root_expr) { expr | noop }

      # Top-level element is any possible expression
      root(:root_expr)

      private

      def ci_str(s)
        Atoms::CaseInsensitiveStr.new(s)
      end

      def padded(other)
        wsp? >> other >> wsp?
      end
    end
  end
end
