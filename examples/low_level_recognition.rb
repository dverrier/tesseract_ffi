# execute from the top-level directory to get the 
# path to the image correct

require 'tesseract_ffi'

#
# This example calls the recogniser and
# prints the results in raw text form and
# xml form

puts "Found Tesserect #{TesseractFFI.version}"
filename = 'test/images/4words.png'
image = TesseractFFI.tess_pix_read(filename)

lang = 'eng'
handle = TesseractFFI.tess_create

if TesseractFFI.tess_init(handle, 0, lang, 0) > 0 
  puts "Error initializing tesseract"
end

TesseractFFI.tess_set_image(handle, image)


TesseractFFI.tess_set_source_resolution(handle, 90)

if TesseractFFI.tess_recognize(handle, 0) > 0
  puts "Error in Tesseract recognition"
end

# print the text directly
puts TesseractFFI.tess_get_utf8(handle,0)

# print the HOCR format
puts  TesseractFFI.tess_get_hocr(handle,0)

TesseractFFI.tess_end(handle)
TesseractFFI.tess_delete(handle)

