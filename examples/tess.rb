    require 'tesseract_ffi'

    puts TesseractFFI.version
    filename = 'test/images/4words.png'
    image = TesseractFFI.tess_pix_read(filename)

    lang = 'eng'
    handle = TesseractFFI.tess_create

    # TesseractFFI.tess_oem_mode()
    # oem = 0
if TesseractFFI.tess_init(handle, 0, lang, 0) > 0 
  puts "Error initializing tesseract"
end


# result =
#     TesseractFFI.tess_get_variable_as_string(
#         handle, 
#             var_name, 
#         ptr)
#     puts "Get var as string #{result}"
#     answer = ptr.read_pointer()
    # puts str_ptr[:value]




    TesseractFFI.tess_set_image(handle, image)


   TesseractFFI.tess_set_source_resolution(handle, 90)
   # TesseractFFI.set_output_name('david.txt')

    if TesseractFFI.tess_recognize(handle, 0) > 0
      puts "Error in Tesseract recognition"
    end

    text = TesseractFFI.tess_get_utf8(handle,0)
    puts text

    hocr = TesseractFFI.tess_get_hocr(handle,0)
    puts hocr

   # TesseractFFI.tess_set_rectangle(handle, 300, 1, 41, 14)
    # text = TesseractFFI.get_utf8(handle)
    # puts text

    TesseractFFI.tess_end(handle)
    TesseractFFI.tess_delete(handle)

