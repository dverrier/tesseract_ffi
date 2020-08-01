require 'helper'

class TestTextRecognition < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name)
    # @recognizer.run
  end




require 'nokogiri'
  def hocr_to_text(str)
    html = Nokogiri::HTML(str)
    extract_words_from_html(html)
  end

  def extract_words_from_html(html)
    pos_info_words = []

    html.css('span.ocrx_word, span.ocr_word')
        .reject { |word| word.text.strip.empty? }
        .each do |word|
      word_attributes = word.attributes['title'].value.to_s
                            .delete(';').split(' ')
      pos_info_word = word_info(word, word_attributes)
      pos_info_words.push pos_info_word
    end
    pos_info_words
  end


  def word_info(word, data)
    {
      word: word.text,
      x_start: data[1].to_i,
      y_start: data[2].to_i,
      x_end: data[3].to_i,
      y_end: data[4].to_i
    }
  end


  def test_text_recognition
    @recognizer.recognize
    assert_equal 'Name Arial Century Peter', @recognizer.utf8_text.strip
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
    @recognizer.recognize
    assert_equal hocr_to_text(hocr), hocr_to_text(@recognizer.hocr_text)
  end

  def test_rectangle_recognition
    @recognizer.recognize_rectangle(300, 0, 41, 15)
    assert_equal 'Peter', @recognizer.utf8_text.strip
  end

  def test_legacy_text_recognition
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name,oem: TesseractFFI::Legacy)
    @recognizer.recognize
    # lower accuracy in legacy mode
    assert_equal 'Name Arial Century Pemr', @recognizer.utf8_text.strip
  end

end
