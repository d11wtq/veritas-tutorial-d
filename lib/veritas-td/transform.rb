module Veritas
  module TD
    class Transform < Parslet::Transform
      # No-ops (whitespace, comments etc)
      rule(:noop => simple(:noop))

      # Simple integer
      rule(:int => simple(:int)) { Integer(int) }

      # Simple strings
      rule(:escaped_char => simple(:char)) { eval('"' + char + '"') }
      rule(:chars => simple(:chars))       { chars }
      rule(:string => sequence(:chunks))   { chunks.join }

      # Logical grouping
      rule(:parenthesized => subtree(:expr)) { expr }

      # +expr and -expr
      rule(:minus => simple(:minus), :value => simple(:value)) { -value }
      rule(:plus  => simple(:minus), :value => simple(:value)) { value }

      # a + b - c * d / e
      rule(:sum      => { :left => simple(:left), :right => simple(:right) }) { left + right }
      rule(:subtract => { :left => simple(:left), :right => simple(:right) }) { left - right }
      rule(:multiply => { :left => simple(:left), :right => simple(:right) }) { left * right }
      rule(:divide   => { :left => simple(:left), :right => simple(:right) }) { Float(left) / right }

      # TABLE_DEE / TABLE_DUM
      rule(:table_dee => simple(:dee)) { Veritas::TABLE_DEE }
      rule(:table_dum => simple(:dum)) { Veritas::TABLE_DUM }

      # RELATION { .. }
      rule(:relation => simple(:empty))   { Veritas::Relation.new([], []) }
      rule(:relation => subtree(:tuples)) { Veritas::Relation.new([], [tuples]) }

      # TUPLE { .. }
      rule(:tuple => subtree(:components)) { [] }
    end
  end
end
