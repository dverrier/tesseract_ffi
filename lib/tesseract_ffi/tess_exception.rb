# frozen_string_literal: true

module TesseractFFI
  # class TessException
  class TessException < Gem::Exception
    attr :error
    def initialize(error_msg)
      @error = error_msg
    end
  end
end
