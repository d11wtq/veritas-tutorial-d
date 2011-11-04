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

      # +expr and -expr
      rule(:minus => simple(:minus), :value => simple(:value)) { -value }
      rule(:plus  => simple(:minus), :value => simple(:value)) { value }

      # a + b
      rule(:sum => { :left => simple(:left), :right => simple(:right) }) { left + right }

      # a - b
      rule(:subtract => { :left => simple(:left), :right => simple(:right) }) { left - right }

      # a * b
      rule(:multiply => { :left => simple(:left), :right => simple(:right) }) { left * right }

      # a / b
      rule(:divide => { :left => simple(:left), :right => simple(:right) }) { Float(left) / right }
    end
  end
end
