module Veritas
  module TD
    class Transform < Parslet::Transform
      # String literals
      rule(:char_str     => simple(:char_str))      { |dict| dict[:char_str] }
      rule(:escaped_char => simple(:escaped_char))  { |dict| dict[:escaped_char].to_s.reverse.chop }
      rule(:string       => subtree(:chars))        { |dict| dict[:chars].join }

      # Integer literals
      rule(:integer => simple(:integer)) { |dict| dict[:integer].to_i }

      # TUPLE { }
      rule(:tuple => simple(:tuple)) { [] }

      # RELATION { }
      rule(:relation => simple(:relation),
           :tuples   => simple(:ignored)) do |dict|
        Veritas::Relation.new([], [])
      end

      # RELATION { TUPLE { .. }, TUPLE { .. } }
      rule(:relation => simple(:relation),
           :tuples   => subtree(:tuples)) do |dict|
        Veritas::Relation.new([], dict[:tuples])
      end
    end
  end
end
