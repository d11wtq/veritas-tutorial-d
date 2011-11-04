module Veritas
  module TD
    class Transform < Parslet::Transform
      # Simple integer
      rule(:int => simple(:int))   { Integer(int) }

      # +expr and -expr
      rule(:minus => simple(:minus), :value => simple(:value)) { 0 - value }
      rule(:plus  => simple(:minus), :value => simple(:value)) { value }
    end
  end
end
