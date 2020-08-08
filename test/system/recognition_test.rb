require 'helper'

class TestTextRecognition < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    # @recognizer.run
  end

  require 'hocr_reader'

  def test_text_recognition
    @tess.recognize
    assert_equal 'Name Arial Century Peter', @tess.utf8_text.strip
  end

  def test_hocr_recognition
hocr = <<HEREDOC
  <div class='ocr_page' id='page_8818' title='image ""; bbox 0 0 341 17; ppageno 8817'>
   <div class='ocr_carea' id='block_8818_1' title="bbox 0 0 341 17">
    <p class='ocr_par' id='par_8818_1' lang='eng' title="bbox 0 0 341 17">
     <span class='ocr_line' id='line_8818_1' title="bbox 0 0 341 17; baseline -0.012 -1; x_size 16; x_descenders 4; x_ascenders 4">
      <span class='ocrx_word' id='word_8818_1' title='bbox 0 4 49 17; x_wconf 92'>Name</span>
      <span class='ocrx_word' id='word_8818_2' title='bbox 54 4 94 17; x_wconf 90'>Arial</span>
      <span class='ocrx_word' id='word_8818_3' title='bbox 237 0 296 15; x_wconf 90'>Century</span>
      <span class='ocrx_word' id='word_8818_4' title='bbox 302 0 341 12; x_wconf 90'>Peter</span>
     </span>
    </p>
   </div>
  </div>
HEREDOC
    @tess.recognize
    r = HocrReader::Reader.new(@tess.hocr_text)
    r.to_words
    assert_equal "Name Arial Century Peter ", r.convert_to_string
  end

  def test_rectangle_recognition
    @tess.recognize_rectangle(300, 0, 41, 15)
    assert_equal 'Peter', @tess.utf8_text.strip
  end

  def test_legacy_text_recognition
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LEGACY)
    @tess.recognize
    # lower accuracy in legacy mode
    assert_equal 'Name Arial Century Pemr', @tess.utf8_text.strip
  end

end
