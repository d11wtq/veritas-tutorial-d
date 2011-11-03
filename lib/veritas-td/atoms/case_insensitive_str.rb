require "parslet"

module Veritas
  module TD
    module Atoms
      class CaseInsensitiveStr < Parslet::Atoms::Str
        def initialize(s)
          super(s.downcase)
        end

        def try(source, context)
          error_pos = source.pos
          s = source.read(str.size)

          return success(s) if s.to_s.downcase == str

          return error(source, "Premature end of input") unless s && s.size == str.size
          return error(source, "Expected #{str.inspect}, but got #{s.inspect}", error_pos) unless s.to_s.downcase == str
        end
      end
    end
  end
end
