# frozen_string_literal: true

require 'helper'

class TestPDF < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    # @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
  end

  def test_pdf_conversion
    out_file_root = 'tmp/new'
    out_file_name = out_file_root + '.pdf'
    File.delete(out_file_name) if File.exist?(out_file_name)
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    @tess.convert_to_pdf out_file_root
    assert File.exist?(out_file_name)
    File.delete(out_file_name) if File.exist?(out_file_name)
  end
end
