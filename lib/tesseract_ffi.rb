require 'ffi'
require 'tesseract_ffi/version'
require 'tesseract_ffi/conf_vars' # mix-in to tesseract
require 'tesseract_ffi/oem'  # mix-in to tesseract
require 'tesseract_ffi/tesseract'
require 'tesseract_ffi/tess_exception'
require 'tesseract_ffi/quick'



module TesseractFFI
  extend FFI::Library

  # OCR Engine Modes OEM
  Legacy = 0
  LTSM = 1
  Legacy_LTSM = 2
  Default = 3

  class FFIIntPtr < FFI::Struct
    layout  :value, :int
  end

  class FFIDoublePtr < FFI::Struct
    layout :value, :double
  end


  ffi_lib '/usr/lib/x86_64-linux-gnu/libtesseract.so'

  attach_function :version, 'TessVersion', [], :string
  attach_function :tess_create, 'TessBaseAPICreate', [],:pointer
  attach_function :tess_delete, 'TessBaseAPIDelete', [:pointer], :int

  attach_function :tess_init3,
    'TessBaseAPIInit3', [:pointer, :int, :string], :int
  attach_function :tess_init,
    'TessBaseAPIInit2', [:pointer, :int, :string, :int], :int

  attach_function :tess_end,
    'TessBaseAPIEnd', [:pointer], :int

  attach_function :tess_set_image,
    'TessBaseAPISetImage2', [:pointer,:buffer_in], :int
  attach_function :tess_recognize,
    'TessBaseAPIRecognize', [:pointer, :int], :int
  attach_function :tess_pix_read,
    'pixRead', [:string], :pointer

  attach_function :tess_get_utf8,
    'TessBaseAPIGetUTF8Text', [:pointer,:int], :string
  attach_function :tess_get_hocr,
    'TessBaseAPIGetHOCRText', [:pointer,:int], :string

  attach_function :tess_set_rectangle,
    'TessBaseAPISetRectangle',[:pointer,:int,:int,:int,:int], :void
  attach_function :tess_set_source_resolution,
    'TessBaseAPISetSourceResolution', [:pointer,:int], :void
  attach_function :tess_set_output_name, 'TessBaseAPISetOutputName',[:pointer], :void

  attach_function :tess_print_to_file, 'TessBaseAPIPrintVariablesToFile',[:pointer, :buffer_in],:bool

  attach_function :tess_get_int_variable, 'TessBaseAPIGetIntVariable',[:pointer, :pointer, FFIIntPtr],:bool
  attach_function :tess_get_double_variable, 'TessBaseAPIGetDoubleVariable',[:pointer, :pointer, FFIDoublePtr], :bool
  attach_function :tess_set_variable, 'TessBaseAPISetVariable', [:pointer, :pointer, :pointer],:bool
  # GetVariableAsString not supported by C API
  # attach_function :tess_get_variable_as_string, 'TessBaseAPIGetVariableAsString', [:pointer, :string, :pointer], :bool

 

  attach_function :tess_get_init_languages_as_string,'TessBaseAPIGetInitLanguagesAsString',[:pointer],:string
  attach_function :tess_get_oem, 'TessBaseAPIOem',[:pointer],:int
  attach_function :tess_get_datapath, 'TessBaseAPIGetDatapath',[:pointer],:pointer
  attach_function :tess_pdf_renderer_create, 'TessPDFRendererCreate', [:pointer,:pointer,:bool ],:pointer
  attach_function :tess_process_pages, 'TessBaseAPIProcessPages', [:pointer,:pointer, :pointer,:int,:pointer],:bool

end
