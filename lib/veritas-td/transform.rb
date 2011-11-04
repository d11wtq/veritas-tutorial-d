module Veritas
  module TD
    class Transform < Parslet::Transform
      # No-ops (whitespace, comments etc)
      rule(:noop => simple(:noop))

      # Simple integer
      rule(:int => simple(:int))   { Integer(int) }

      # Simple strings
      rule(:escaped_char => simple(:char)) { eval('"' + char + '"') }
      rule(:chars => simple(:chars))       { chars }
      rule(:string => sequence(:chunks))   { chunks.join }

      # +expr and -expr
      rule(:minus => simple(:minus), :value => simple(:value)) { 0 - value }
      rule(:plus  => simple(:minus), :value => simple(:value)) { value }
    end
  end
end
