# frozen_string_literal: true

module TesseractFFI
  # class Tesseract
  class Tesseract
    include TesseractFFI
    include ConfVars
    include OEM

    attr_accessor :language, :file_name, :source_resolution
    attr_reader :utf8_text, :hocr_text, :errors

    def initialize(file_name: nil, language: 'eng', source_resolution: 72, oem: DEFAULT)
      @language = language
      raise TessException.new(error_msg: 'file_name must be provided') unless file_name

      raise TessException.new(error_msg: "File #{file_name} not found") unless File.exist? file_name

      @file_name = file_name
      @source_resolution = source_resolution
      @oem = oem
      @errors = []
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
      raise
    ensure
      tess_end(@handle)
      tess_delete(@handle)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def ocr
      tess_set_source_resolution(@handle, @source_resolution)
      raise TessException.new(error_msg: 'Recognition Error') if tess_recognize(@handle, 0) != 0

      @utf8_text = ''
      text = tess_get_utf8(@handle, 0)
      @utf8_text = text.encode('UTF-8') if text
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

    def set_rectangle(x_coord, y_coord, width, height)
      tess_set_rectangle(@handle, x_coord, y_coord, width, height)
    end

    def recognize_rectangle(x_coord, y_coord, width, height)
      setup do
        set_rectangle(x_coord, y_coord, width, height)
        ocr
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def recognize_rectangles(rectangle_list)
      unless rectangle_list.is_a?(Array) && rectangle_list.length.positive?
        msg = 'Tess Error Argument must be a list'
        # copy the error message as we are not going to Setup
        @errors << msg
        raise TessException.new(error_msg: msg)
      end

      texts = []
      setup do
        rectangle_list.each do |r|
          unless r.is_a?(Array) && rectangle_list.length > 3
            msg = 'Argument must be a list of 4-arrays'
            raise TessException.new(error_msg: msg)
          end

          set_rectangle(r[0], r[1], r[2], r[3])
          ocr
          texts << @utf8_text.strip
        end
      end
      texts
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
