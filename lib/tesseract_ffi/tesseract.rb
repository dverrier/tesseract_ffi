# frozen_string_literal: true

module TesseractFFI
  # class Tesseract
  class Tesseract
    include TesseractFFI
    include ConfVars
    include OEM
    include Rectangles

    attr_accessor :language, :file_name, :source_resolution
    attr_reader :utf8_text, :hocr_text, :errors

    def initialize(file_name: nil, language: 'eng', source_resolution: 72, oem: DEFAULT)
      unless file_name.is_a?(String) && File.exist?(file_name)
        log 'Error: Tesseract needs a file ' + (file_name || 'no name given')
        raise TessException.new(error_msg: 'file_name must be provided')
      end

      @file_name = file_name
      @language = language
      @source_resolution = source_resolution
      @oem = oem
      @errors = []
    end

    # just output to console
    def log(msg)
      puts msg
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def setup
      @handle = tess_create
      raise TessException.new(error_msg: 'Library Error') unless @handle

      result = tess_init(@handle, 0, @language, @oem)
      raise TessException.new(error_msg: 'Init Error') if result != 0

      @image = tess_pix_read(@file_name)
      image_status = tess_set_image(@handle, @image)
      raise TessException.new(error_msg: "Unable to set image #{@file_name}") if image_status != 0

      yield # run the block for recognition etc
    rescue TessException => e
      @errors << "Tesseract Error #{e.error[:error_msg]}"
      log @errors
      raise
    ensure
      tess_end(@handle)
      tess_delete(@handle)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def ocr
      tess_set_source_resolution(@handle, @source_resolution)
      raise TessException.new(error_msg: 'Recognition Error') if tess_recognize(@handle, 0) != 0

      @utf8_text = tess_get_utf8(@handle, 0)
      @hocr_text = tess_get_hocr(@handle, 0)
    end

    def recognize
      setup do
        ocr
      end
    end

    def convert_to_pdf(output_stem)
      setup do
        datapath = TesseractFFI.tess_get_datapath(@handle)
        pdf_renderer = TesseractFFI.tess_pdf_renderer_create(output_stem, datapath, false)
        TesseractFFI.tess_process_pages(@handle, @file_name, nil, 5000, pdf_renderer)
      end
    end
  end
end
