# frozen_string_literal: true

module TesseractFFI
  # module OEM
  module OEM
    def oem
      ocr_engine_mode = nil
      setup do
        ocr_engine_mode = TesseractFFI.tess_get_oem(@handle)
      end
      ocr_engine_mode
    end
  end
end
