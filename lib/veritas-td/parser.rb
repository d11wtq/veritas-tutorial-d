require "parslet"

module Veritas
  module TD
    class Parser < Parslet::Parser
      rule(:wsp)        { match('\s').repeat }
      rule(:wsp?)       { wsp.maybe }

      rule(:relation_t) { ci_str("RELATION") }
      rule(:relation)   { relation_t.as(:relation) >> wsp? >> str("{") >> wsp? >> tuple_set.as(:tuples) >> wsp? >> str("}") }

      rule(:tuple_t)    { ci_str("TUPLE") }
      rule(:tuple)      { tuple_t.as(:tuple) >> wsp? >> str("{") >> wsp? >> str("}") }

      rule(:tuple_set)  { (tuple >> wsp?).repeat(0, 1) >> (str(",") >> wsp? >> tuple).repeat }

      rule(:expr)       { relation }

      root(:expr)

      private

      def ci_str(s)
        Atoms::CaseInsensitiveStr.new(s)
      end
    end
  end
end
