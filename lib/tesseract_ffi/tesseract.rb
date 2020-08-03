module TesseractFFI
  class Tesseract

    include TesseractFFI  
    include ConfVars
    include OEM

    attr_accessor :language, :file_name, :source_resolution
    attr_reader :utf8_text, :hocr_text, :errors

    def initialize(file_name: nil, language: 'eng', source_resolution: 72, oem: Default)
      @language = language
      if file_name
        if File.exist? file_name
          @file_name = file_name
        else 
          raise TessException.new( error_msg: "File #{file_name} not found")
        end
      else
        raise TessException.new(error_msg: 'file_name must be provided')
      end
      @source_resolution = source_resolution
      @oem = oem
      @errors = ''
    end

    def setup
      begin
        @handle = tess_create
        unless @handle
          raise TessException.new(error_msg: 'Library Error')
        end
        result = tess_init(@handle, 0, @language, @oem)
        if  result != 0 
          raise TessException.new(error_msg: 'Init Error')
        end

        @image = tess_pix_read(@file_name)
        image_status = tess_set_image(@handle, @image) 
        if image_status != 0
          raise TessException.new(error_msg: "Unable to set image #{@file_name}") 
        end
        yield # run the block for recognition etc

      rescue TessException => exception
        @errors << "Tesseract Error #{exception.error[:error_msg]}"
        raise
      ensure
        tess_end(@handle)
        tess_delete(@handle)
      end
    end

    def ocr
      tess_set_source_resolution(@handle, @source_resolution)
      if tess_recognize(@handle, 0) != 0
        raise TessException.new(error_msg: 'Recognition Error')
      end
      @utf8_text = ''
      text = tess_get_utf8(@handle,0)
      if text
        @utf8_text = text.encode("UTF-8")
      end
      @hocr_text = tess_get_hocr(@handle,0)
    end

    def recognize
      setup do
        ocr
      end
    end

    def convert_to_pdf(output_stem)
      setup() do
        datapath = TesseractFFI.tess_get_datapath(@handle)
        pdf_renderer = TesseractFFI.tess_pdf_renderer_create(output_stem, datapath, false)
        TesseractFFI.tess_process_pages(@handle, @file_name, nil, 5000, pdf_renderer)
      end
    end

    def set_rectangle(x,y,w,h)
      tess_set_rectangle(@handle, x, y, w, h)
    end

    def recognize_rectangle(x,y,w,h)
      setup() do  
        set_rectangle(x,y,w,h)
        ocr
      end
    end

  end
end