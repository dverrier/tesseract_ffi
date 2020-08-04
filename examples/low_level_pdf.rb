# execute from the top-level directory to get the 
# path to the image correct

require 'tesseract_ffi'
#
# This example shows how to use the low-level functions directly
# to convert an image to a searchable pdf file
#
 
input_filename = 'test/images/4words.png'
output_stem = 'myfirst'
image = TesseractFFI.tess_pix_read(input_filename)


lang = 'eng'
handle = TesseractFFI.tess_create

if TesseractFFI.tess_init(handle, 0, lang, 0) > 0 
  puts "Error initializing tesseract"
end

TesseractFFI.tess_set_image(handle, image)

datapath = TesseractFFI.tess_get_datapath(handle)
pdf_renderer = TesseractFFI.tess_pdf_renderer_create(output_stem, datapath, false)
TesseractFFI.tess_process_pages(handle, input_filename, nil, 5000, pdf_renderer)
puts "PDF file " + output_stem + ".pdf written"

TesseractFFI.tess_end(handle)
TesseractFFI.tess_delete(handle)

