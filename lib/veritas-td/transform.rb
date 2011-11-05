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
      rule(:relation => subtree(:tuples)) do |dict|
        Veritas::Relation.new(tuple_header(dict[:tuples]), tuple_set(dict[:tuples]))
      end

      # TUPLE { .. }
      rule(:tuple => simple(:empty))        { [] }
      rule(:tuple => subtree(:components))  { components }
      rule(:attribute_ref => simple(:name)) { name.to_sym }

      # FIXME: Create factory classes
      class << self
        private

        def tuple_header(tuples)
          tuples.first.collect do |attribute|
            [attribute[:name], attribute_type(attribute[:value])]
          end
        end

        def attribute_type(value)
          case value
            when Fixnum, Integer
              Integer
            else
              Object # ?
          end
        end

        def tuple_set(tuples)
          tuples.collect do |tuple|
            tuple.collect { |attribute| attribute[:value] }
          end
        end
      end
    end
  end
end
