require 'helper'

class TestException < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_file_name_not_given
    assert_raises TesseractFFI::TessException do
      TesseractFFI::Recognizer.new
    end
  end

  def test_file_name_not_exist
    assert_raises TesseractFFI::TessException do
      TesseractFFI::Recognizer.new(file_name: 'toto.png')
    end
  end

  def test_library_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(nil) # error value not a pointer
    recognizer.expects(:tess_end).with(nil)

    assert_raises TesseractFFI::TessException do
      recognizer.setup_tesseract()
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Library Error', recognizer.errors
  end

  def test_init_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    # @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(1) # error value
    recognizer.expects(:tess_end).with(@handle)

    assert_raises TesseractFFI::TessException do
      recognizer.setup_tesseract()
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Init Error', recognizer.errors
  end


  def test_image_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(1) # error value
    assert_raises TesseractFFI::TessException do
      recognizer.setup_tesseract()
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Unable to set image test/images/4words.png', recognizer.errors
  end


  def test_recognize_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    recognizer.expects(:tess_recognize).with(@handle, 0).returns(-1)
    assert_raises TesseractFFI::TessException do
      recognizer.recognize
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Recognition Error', recognizer.errors
  end

  def test_variable_get_double_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    assert_raises TesseractFFI::TessException do
      recognizer.setup_tesseract {recognizer.get_double_variable('NOTHING')}
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Unable to get config variable NOTHING', recognizer.errors
  end

  def test_variable_get_int_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    assert_raises TesseractFFI::TessException do
      recognizer.setup_tesseract {recognizer.get_integer_variable('NOTHING')}
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Unable to get config variable NOTHING', recognizer.errors
  end

  def test_variable_set_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    assert_raises TesseractFFI::TessException do
      recognizer.setup_tesseract {recognizer.set_variable('NOTHING', '22')}
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Unable to set config variable NOTHING', recognizer.errors
  end

end
