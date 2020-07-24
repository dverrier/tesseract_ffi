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
      @image = TesseractFFI.pix_read(@file_name)
      begin
        @handle = tess_create
        unless @handle
          raise TessException.new(error_msg: 'Library Error')
        end

        run_tesseract(@handle, @language, @image)
      rescue TessException => exception
        @errors << "Tesseract Error #{exception.error[:error_msg]}"
        raise
      ensure
        tess_end(@handle)
        tess_delete(@handle)
      end
    end


    def run_tesseract(handle,language, image)
      result = tess_init(handle, 0, language)
      if  result != 0 
        raise TessException.new(error_msg: 'Init Error')
      end

      image_status = set_image(handle, image) 
      if image_status != 0
        raise TessException.new(error_msg: "Unable to set image #{@file_name}") 
      end
      
      set_source_resolution(handle, @source_resolution)
      if recognize(handle, 0) != 0
        raise TessException.new(error_msg: 'Recognition Error')
      end
      
      text = get_utf8(handle)
      @utf8_text = text.encode("UTF-8")
      @hocr_text = get_hocr(handle)
    end

  end
end