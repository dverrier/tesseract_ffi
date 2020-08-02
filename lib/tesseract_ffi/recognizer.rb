module TesseractFFI
  class Recognizer

    include TesseractFFI

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

    def setup_tesseract
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
        yield # run the block for either recognition or rectangle

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
      text = tess_get_utf8(@handle,0)
      if text
        @utf8_text = text.encode("UTF-8")
      else
        @utf8_text = ''
      end
      @hocr_text = tess_get_hocr(@handle,0)
    end

    def recognize
      setup_tesseract do
        run_ocr
      end
    end

    def set_rectangle(x,y,w,h)
      tess_set_rectangle(@handle, x, y, w, h)
    end

    def recognize_rectangle(x,y,w,h)
      setup_tesseract() do  
        set_rectangle(x,y,w,h)
        run_ocr
      end
    end

    def get_double_variable(var_name)
      var_value = nil
      d_ptr = TesseractFFI::FFIDoublePtr.new

      result = tess_get_double_variable(@handle, var_name, d_ptr)
      if result 
        var_value = d_ptr[:value]
      else
        raise TessException.new(error_msg: 'Unable to get config variable ' + var_name)
      end
      var_value
    end

    def get_integer_variable(var_name)
      var_value = nil
      i_ptr = TesseractFFI::FFIIntPtr.new
      result = tess_get_int_variable(@handle, var_name, i_ptr)
      if result 
        var_value = i_ptr[:value]
      else
        raise TessException.new(error_msg: 'Unable to get config variable ' + var_name)
      end
      var_value
    end

    def set_variable(var_name, value)
      set_result = nil
      mem_ptr = FFI::MemoryPointer.from_string(value.to_s)
      result = tess_set_variable(@handle, var_name, mem_ptr)
      if result
        set_result = true
      else
        raise TessException.new(error_msg: 'Unable to set config variable ' + var_name)
      end
      set_result
    end

    def print_variables_to_file(file_name)
      result = TesseractFFI.tess_print_to_file(@handle, file_name)
      unless result
        raise TessException.new(error_msg: 'Unable to print variable to ' + file_name)
      end
      result
    end


    def oem
      ocr_engine_mode = nil
      setup_tesseract do
        ocr_engine_mode = TesseractFFI.tess_get_oem(@handle)
      end
      ocr_engine_mode
    end

  end
end