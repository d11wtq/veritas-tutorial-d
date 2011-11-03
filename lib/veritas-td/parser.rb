require "parslet"

module Veritas
  module TD
    class Parser < Parslet::Parser
      # Whitespace
      rule(:wsp)        { match('\s').repeat }
      rule(:wsp?)       { wsp.maybe }

      rule(:scalar)         { string_literal | integer_literal }

      # Character string literals
      rule(:escaped_char)   { str("\\") >> any }
      rule(:squot_content)  { escaped_char.as(:escaped_char) | match("[^'\\\\]+").repeat(1).as(:char_str) }
      rule(:squot_literal)  { str("'") >> squot_content.repeat.as(:string) >> str("'") }
      rule(:dquot_content)  { escaped_char.as(:escaped_char) | match('[^"\\\\]+').repeat(1).as(:char_str) }
      rule(:dquot_literal)  { str('"') >> dquot_content.repeat.as(:string) >> str('"') }
      rule(:string_literal) { squot_literal | dquot_literal }

      # Integer literals
      rule(:integer_literal) { (str("-").maybe >> match["0-9"].repeat(1)).as(:integer) }

      rule(:relation_t) { ci_str("RELATION") }
      rule(:relation)   { relation_t.as(:relation) >> wsp? >> str("{") >> wsp? >> tuple_set.as(:tuples) >> wsp? >> str("}") }

      rule(:tuple_t)    { ci_str("TUPLE") }
      rule(:tuple)      { tuple_t.as(:tuple) >> wsp? >> str("{") >> wsp? >> str("}") }

      rule(:tuple_set)  { (tuple >> wsp?).repeat(0, 1) >> (str(",") >> wsp? >> tuple).repeat }

      rule(:expr)       { relation | scalar }

      root(:expr)

      private

      def ci_str(s)
        Atoms::CaseInsensitiveStr.new(s)
      end
    end
  end
end
