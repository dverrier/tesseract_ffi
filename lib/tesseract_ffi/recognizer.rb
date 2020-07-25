module TesseractFFI
  class Recognizer

    include TesseractFFI

    attr_accessor :language, :file_name, :source_resolution
    attr_reader :utf8_text, :hocr_text, :errors

    def initialize(language: 'eng', file_name: 'tesseractffi', source_resolution: 72)
      @language = language
      @file_name = file_name
      @source_resolution = source_resolution
      @errors = ''
    end

    # def recognize2
    #   @image = TesseractFFI.pix_read(@file_name)
    #   @handle = TesseractFFI.create
        
    #   if TesseractFFI.init(@handle, 0, @language) > 0 
    #     raise "Exception: Error initializing tesseract"
    #   end
    #   TesseractFFI.set_image(@handle, @image)
    #   TesseractFFI.set_source_resolution(@handle, @source_resolution)

    #   if TesseractFFI.recognize(@handle, 0) > 0
    #     raise "Exception: Error in Tesseract recognition"
    #   end

    #    @utf8_text = TesseractFFI.get_utf8(@handle).encode("UTF-8")
        
    #   TesseractFFI.end(@handle)      
    #   TesseractFFI.delete(@handle)
    # end

    def run
      @image = tess_pix_read(@file_name)
      begin
        @handle = tess_create
        unless @handle
          raise TessException.new(error_msg: 'Library Error')
        end
        result = tess_init(@handle, 0, @language)
        if  result != 0 
          raise TessException.new(error_msg: 'Init Error')
        end

        image_status = tess_set_image(@handle, @image) 
        if image_status != 0
          raise TessException.new(error_msg: "Unable to set image #{@file_name}") 
        end

        # recognize
        yield

      rescue TessException => exception
        @errors << "Tesseract Error #{exception.error[:error_msg]}"
        raise
      ensure
        tess_end(@handle)
        tess_delete(@handle)
      end
    end

    def run_ocr
      tess_set_source_resolution(@handle, @source_resolution)
      if tess_recognize(@handle, 0) != 0
        raise TessException.new(error_msg: 'Recognition Error')
      end
      text = tess_get_utf8(@handle)
      if text
        @utf8_text = text.encode("UTF-8")
      else
        @utf8_text = ''
      end
      @hocr_text = tess_get_hocr(@handle)
    end

   def recognize
      self.run() do
        run_ocr
      end
    end

    def set_rectangle(x,y,w,h)
      tess_set_rectangle(@handle, x, y, w, h)
    end

    def recognize_rectangle(x,y,w,h)
      self.run() do 
        set_rectangle(x,y,w,h)
        run_ocr
      end
    end

  end
end