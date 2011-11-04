require "parslet"

module Veritas
  module TD
    class Parser < Parslet::Parser
      # Whitespace
      rule(:wsp)        { match('\s').repeat }
      rule(:wsp?)       { wsp.maybe }

      # Integers
      rule(:int_lit)    { match["0-9"].repeat(1).as(:int) }

      # Expressions
      rule(:unary_op)    { padded(str("-").as(:minus) | str("+").as(:plus)) }
      rule(:unary_expr)  { unary_op >> int_lit.as(:value) }
      rule(:expr)        { unary_expr | int_lit }

      root(:expr)

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
