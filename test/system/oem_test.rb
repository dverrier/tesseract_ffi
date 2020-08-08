# frozen_string_literal: true

require 'helper'

class OEMTest < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_set_default_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    assert_equal TesseractFFI::DEFAULT, @tess.oem
  end

  def test_set_legacy_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LEGACY)
    assert_equal TesseractFFI::LEGACY, @tess.oem
  end

  def test_set_ltsm_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LTSM)
    assert_equal TesseractFFI::LTSM, @tess.oem
  end

  def test_set_legacy_ltsm_oem
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LEGACY_LTSM)
    assert_equal TesseractFFI::LEGACY_LTSM, @tess.oem
  end
end
