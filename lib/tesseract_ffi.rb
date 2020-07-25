require 'ffi'
require 'tesseract_ffi/recognizer'
require 'tesseract_ffi/tess_exception'

module TesseractFFI
  extend FFI::Library

  ffi_lib '/usr/lib/x86_64-linux-gnu/libtesseract.so'

  attach_function :version, 'TessVersion', [], :string
  attach_function :tess_create, 'TessBaseAPICreate', [],:pointer
  attach_function :tess_delete, 'TessBaseAPIDelete', [:pointer], :int

  attach_function :tess_init,
    'TessBaseAPIInit3', [:pointer, :int, :string], :int
  attach_function :tess_end,
    'TessBaseAPIEnd', [:pointer], :int

  attach_function :tess_set_image,
    'TessBaseAPISetImage2', [:pointer,:buffer_in], :int
  attach_function :tess_recognize,
    'TessBaseAPIRecognize', [:pointer, :int], :int
  attach_function :tess_pix_read,
    'pixRead', [:string], :pointer

  attach_function :tess_get_utf8,
    'TessBaseAPIGetUTF8Text', [:pointer], :string
  attach_function :tess_get_hocr,
    'TessBaseAPIGetHOCRText', [:pointer], :string

  attach_function :tess_set_rectangle,
    'TessBaseAPISetRectangle',[:pointer,:int,:int,:int,:int], :void
  attach_function :tess_set_source_resolution,
    'TessBaseAPISetSourceResolution', [:pointer,:int], :void
  attach_function :tess_set_output_name, 'TessBaseAPISetOutputName',[:pointer], :void
end
