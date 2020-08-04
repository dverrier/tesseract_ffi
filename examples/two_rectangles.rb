require 'tesseract_ffi'
tess = TesseractFFI::Tesseract.new( 
      file_name: 'test/images/4words.png', 
      source_resolution:96)

tess.setup do
  # x,y,w,h
  tess.set_rectangle(300, 0, 40, 20)
  tess.ocr
  puts tess.utf8_text
  tess.set_rectangle(0,0,340,17)
  tess.ocr
  puts tess.utf8_text
  # and so on
end