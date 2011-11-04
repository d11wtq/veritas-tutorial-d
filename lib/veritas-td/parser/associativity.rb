require "parslet"

module Veritas
  module TD
    class Associativity < Parslet::Transform
      # FIXME: Make this generic and mix it into the parser, something like:
      #        left(:multiply)
      #        left(:divide)
      rule(:multiply => { :left => subtree(:left), :right => { :sum => { :left => subtree(:sub_left), :right => subtree(:sub_right) } } }) do
        { :sum => { :left => { :multiply => { :left => left, :right => sub_left } }, :right => sub_right } }
      end

      rule(:multiply => { :left => subtree(:left), :right => { :subtract => { :left => subtree(:sub_left), :right => subtree(:sub_right) } } }) do
        { :subtract => { :left => { :multiply => { :left => left, :right => sub_left } }, :right => sub_right } }
      end

      rule(:divide => { :left => subtree(:left), :right => { :sum => { :left => subtree(:sub_left), :right => subtree(:sub_right) } } }) do
        { :sum => { :left => { :divide => { :left => left, :right => sub_left } }, :right => sub_right } }
      end

      rule(:divide => { :left => subtree(:left), :right => { :subtract => { :left => subtree(:sub_left), :right => subtree(:sub_right) } } }) do
        { :subtract => { :left => { :divide => { :left => left, :right => sub_left } }, :right => sub_right } }
      end
    end
  end
end
