require 'helper'

class TestQuick < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    # @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
  end

  def test_quick_text_recognition
    t = TesseractFFI.to_text(@image_name)
    assert_equal 'Name Arial Century Peter', t.strip
  end

  def test_quick_pdf_conversion
    out_file_root = 'tmp/new'
    out_file_name = out_file_root + '.pdf'
    File.delete(out_file_name) if File.exist?(out_file_name)

    TesseractFFI.to_pdf(@image_name, out_file_root)
    
    assert File.exist?(out_file_name)
    File.delete(out_file_name) if File.exist?(out_file_name )
  end

end
