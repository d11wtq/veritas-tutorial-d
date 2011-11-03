module Veritas
  module TD
    class Transform < Parslet::Transform
      # TUPLE { }
      rule(:tuple    => simple(:tuple))    { [] }

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
