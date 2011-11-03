require "parslet"

module Veritas
  module TD
    class Interpreter
      def eval(expr)
        p parser.parse(expr)
        transform.apply(parser.parse(expr))
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
