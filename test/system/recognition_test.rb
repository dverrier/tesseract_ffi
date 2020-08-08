# frozen_string_literal: true

require 'helper'

class TestTextRecognition < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
  end

  require 'hocr_reader'

  def test_text_recognition
    @tess.recognize
    assert_equal 'Name Arial Century Peter', @tess.utf8_text.strip
  end

  def test_hocr_recognition
    @tess.recognize
    r = HocrReader::Reader.new(@tess.hocr_text)
    r.to_words
    assert_equal 'Name Arial Century Peter ', r.convert_to_string
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
