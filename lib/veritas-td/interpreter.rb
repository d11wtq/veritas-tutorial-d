require "parslet"

module Veritas
  module TD
    class Interpreter
      def initialize(registry = {})
        @registry = registry.inject({}) { |h, (k, v)| h.merge(k.to_s.upcase.to_sym => v) }
      end

      def eval(expr)
        transform.apply(parser.parse(expr), :registry => @registry)
      end

      private

      def parser
        @parser ||= Parser.new
      end

      def transform
        @transform ||= Transform.new
      end
    end
  end
end
