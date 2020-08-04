
# execute from the top-level directory to get the 
# path to the image correct
require 'tesseract_ffi'
puts TesseractFFI.to_text('test/images/bonjour.png','fra')
# => Bonjour les enfants

