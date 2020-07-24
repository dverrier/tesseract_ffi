module TesseractFFI
  class TessException < Gem::Exception
    attr :error
    def initialize(error_msg)
      @error = error_msg
    end


  end
end