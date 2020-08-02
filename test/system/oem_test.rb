require 'helper'

class OEMTest < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    
  end


  def test_set_default_oem
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name)
    assert_equal TesseractFFI::Default, @recognizer.oem 
  end

  def test_set_legacy_oem
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name, oem: TesseractFFI::Legacy)
    assert_equal TesseractFFI::Legacy, @recognizer.oem 
  end

  def test_set_ltsm_oem
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name, oem: TesseractFFI::LTSM)
    assert_equal TesseractFFI::LTSM, @recognizer.oem 
  end

  def test_set_legacy_ltsm_oem
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name, oem: TesseractFFI::Legacy_LTSM)
    assert_equal TesseractFFI::Legacy_LTSM, @recognizer.oem 
  end
end