    require 'ffi'

    module Tess
      extend FFI::Library
      API = 'TessBaseAPI'
      ffi_lib '/usr/lib/x86_64-linux-gnu/libtesseract.so'
      def tess_base_function(rname, cname, args, returns)
        attach_function rname, API + cname,args, returns
      end

      attach_function :version, 'TessVersion', [], :string
      attach_function :create, 'TessBaseAPICreate', [],:pointer
      attach_function :delete, 'TessBaseAPIDelete', [:pointer], :int

      attach_function :init,
        'TessBaseAPIInit3', [:pointer, :int, :string], :int
      attach_function :end,
        'TessBaseAPIEnd', [:pointer], :int

      attach_function :set_image,
        'TessBaseAPISetImage2', [:pointer,:buffer_in], :int
      attach_function :recognize,
        'TessBaseAPIRecognize', [:pointer, :int], :int
      attach_function :pix_read,
        'pixRead', [:string], :pointer

      attach_function :get_utf8,
        'TessBaseAPIGetUTF8Text', [:pointer], :string
      attach_function :get_hocr,
        'TessBaseAPIGetHOCRText', [:pointer], :string

      attach_function :set_rectangle,
        'TessBaseAPISetRectangle',[:pointer,:int,:int,:int,:int], :void
      attach_function :set_source_resolution,
        'TessBaseAPISetSourceResolution', [:pointer,:int], :void
    end



    puts "Tess Module"
    puts Tess.version
    filename = 'name833.png'
    image = Tess.pix_read(filename)

    lang = 'eng'
    handle = Tess.create
    if Tess.init(handle, 0, lang) > 0 
      puts "Error initializing tesseract"
    end

    # langs =  Tess.get_langs

    Tess.set_image(handle, image)


   Tess.set_source_resolution(handle, 90)

    if Tess.recognize(handle, 0) > 0
      puts "Error in Tesseract recognition"
    end

    text = Tess.get_utf8(handle)
    puts text

    hocr = Tess.get_hocr(handle)
    puts hocr

   Tess.set_rectangle(handle, 300, 1, 41, 14)
    text = Tess.get_utf8(handle)
    puts text
    Tess.end(handle)
    Tess.delete(handle)
    
    puts "The end"  