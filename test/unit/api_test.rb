# frozen_string_literal: true

require 'helper'

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
class TestAPI < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_tess_defaults
    tess = TesseractFFI::Tesseract.new(file_name: 'test/images/4words.png')
    assert_equal 'eng', tess.language
    assert_equal 'test/images/4words.png', tess.file_name
    assert_equal 72, tess.source_resolution
  end

  def test_tess_configuration
    tess = TesseractFFI::Tesseract.new(
      language: 'deu',
      file_name: 'test/images/4words.png',
      source_resolution: 96
    )
    assert tess
    assert_equal 'deu', tess.language
    assert_equal 'test/images/4words.png', tess.file_name
    assert_equal 96, tess.source_resolution
  end

  def test_tesseract_run_text
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng+lav', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    tess.expects(:tess_set_source_resolution)
    # tess.expects(:tess_recognize).with(@handle, 0).returns(0)
    tess.expects(:tess_get_utf8).with(@handle, 0).returns('ABCD')
    assert_equal 'eng+lav', tess.tess_get_init_languages_as_string(@handle)
    tess.recognize
    TesseractFFI.tess_delete(@handle)
    assert_equal [], tess.errors
    assert_equal 'ABCD', tess.utf8_text
  end

  def test_tess_run_hocr
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    tess.expects(:tess_set_source_resolution)
    tess.expects(:tess_recognize).with(@handle, 0).returns(0)
    tess.expects(:tess_get_hocr).with(@handle, 0).returns('<html></html>')
    tess.recognize
    TesseractFFI.tess_delete(@handle)
    assert_equal [], tess.errors
    assert_equal '<html></html>', tess.hocr_text
  end

  def test_tess_run_rectangle
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    tess.expects(:tess_set_source_resolution)
    tess.expects(:tess_recognize).with(@handle, 0).returns(0)
    tess.expects(:tess_set_rectangle).with(@handle, 1, 2, 3, 4)
    tess.expects(:tess_get_hocr).with(@handle, 0).returns('<html></html>')

    tess.recognize_rectangle(1, 2, 3, 4)
    TesseractFFI.tess_delete(@handle)
    assert_equal [], tess.errors
    assert_equal '<html></html>', tess.hocr_text
  end

  def test_oem
    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    assert_equal TesseractFFI::DEFAULT, tess.oem
    tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LEGACY)
    assert_equal 0, tess.oem
    tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LTSM)
    assert_equal 1, tess.oem
    tess = TesseractFFI::Tesseract.new(file_name: @image_name, oem: TesseractFFI::LEGACY_LTSM)
    assert_equal 2, tess.oem
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
