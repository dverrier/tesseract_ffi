# frozen_string_literal: true

require 'helper'

class TestRectangles < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
  end

  def test_rectangles_recognition
    correct_texts = %w[Name Arial Century Peter]
    # [[x,y,w,h]]
    rectangles = [
      [0, 4, 49, 13],
      [54, 4, 44, 13],
      [237, 0, 60, 15],
      [302, 0, 40, 12]
    ]
    recognized_texts = @tess.recognize_rectangles rectangles
    assert_equal correct_texts, recognized_texts
  end
end
