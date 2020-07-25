require 'helper'

class TestException < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_library_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(nil) # error value not a pointer
    recognizer.expects(:tess_end).with(nil)

    assert_raises TesseractFFI::TessException do
      recognizer.run
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
      recognizer.run
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Init Error', recognizer.errors
  end


  def test_image_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(1) # error value
    assert_raises TesseractFFI::TessException do
      recognizer.run
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Unable to set image test/images/4words.png', recognizer.errors
  end


  def test_recognize_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    recognizer.expects(:tess_set_source_resolution)
    recognizer.expects(:tess_recognize).with(@handle, 0).returns(-1)
    # recognizer.expects(:get_utf8)
    assert_raises TesseractFFI::TessException do
      recognizer.recognize
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Recognition Error', recognizer.errors
  end
end
