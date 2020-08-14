# frozen_string_literal: true

require 'helper'

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize
class TestException < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_file_name_not_given
    assert_raises TesseractFFI::TessException do
      TesseractFFI::Tesseract.new
    end
  end

  def test_file_name_not_exist
    assert_raises TesseractFFI::TessException do
      TesseractFFI::Tesseract.new(file_name: 'toto.png')
    end
  end

  def test_library_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(nil) # error value not a pointer
    tess.expects(:tess_end).with(nil)

    assert_raises TesseractFFI::TessException do
      tess.setup
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Library Error'], tess.errors
  end

  def test_init_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    # @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(1) # error value
    tess.expects(:tess_end).with(@handle)

    assert_raises TesseractFFI::TessException do
      tess.setup
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Init Error'], tess.errors
  end

  def test_image_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(1) # error value
    assert_raises TesseractFFI::TessException do
      tess.setup
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Unable to set image test/images/4words.png'], tess.errors
  end

  def test_recognize_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    tess.expects(:tess_recognize).with(@handle, 0).returns(-1)
    assert_raises TesseractFFI::TessException do
      tess.recognize
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Recognition Error'], tess.errors
  end

  def test_variable_get_double_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    assert_raises TesseractFFI::TessException do
      tess.setup { tess.get_double_variable('NOTHING') }
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Unable to get config variable NOTHING'], tess.errors
  end

  def test_variable_get_int_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    assert_raises TesseractFFI::TessException do
      tess.setup { tess.get_integer_variable('NOTHING') }
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Unable to get config variable NOTHING'], tess.errors
  end

  def test_variable_set_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_create).returns(@handle)
    tess.expects(:tess_delete).with(@handle)

    tess.expects(:tess_init).returns(@init_result)
    tess.expects(:tess_end).with(@handle)
    tess.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    assert_raises TesseractFFI::TessException do
      tess.setup { tess.set_variable('NOTHING', '22') }
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal ['Tesseract Error Unable to set config variable NOTHING'], tess.errors
  end

  def test_variable_print_error
    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.expects(:tess_print_to_file).returns(nil)
    assert_raises TesseractFFI::TessException do
      tess.setup { tess.print_variables_to_file('NOTHING') }
    end
    assert_equal ['Tesseract Error Unable to print variables to NOTHING'], tess.errors
  end

  def test_rectangles_argument_list_error
    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    assert_raises TesseractFFI::TessException do
      tess.recognize_rectangles({})
    end
    assert_equal ['Tess Error Argument must be a list'], tess.errors
  end

  def test_rectangles_argument_content_error
    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    assert_raises TesseractFFI::TessException do
      tess.recognize_rectangles([1, 2, 3])
    end
    assert_equal ['Tesseract Error Argument must be a list of 4-arrays'], tess.errors
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize
