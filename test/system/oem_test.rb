require 'helper'

class OEMTest < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    
  end


  def test_set_default_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    assert_equal TesseractFFI::Default, @tess.oem 
  end

  def test_set_legacy_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::Legacy)
    assert_equal TesseractFFI::Legacy, @tess.oem 
  end

  def test_set_ltsm_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LTSM)
    assert_equal TesseractFFI::LTSM, @tess.oem 
  end

  def test_set_legacy_ltsm_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::Legacy_LTSM)
    assert_equal TesseractFFI::Legacy_LTSM, @tess.oem 
  end
end