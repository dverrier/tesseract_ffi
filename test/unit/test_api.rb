require 'helper'

class TestAPI < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_supported_api_methods
    assert (TesseractFFI.respond_to? :version)
    assert (TesseractFFI.respond_to? :tess_create)
    assert (TesseractFFI.respond_to? :tess_delete)
    assert (TesseractFFI.respond_to? :tess_init)
    assert (TesseractFFI.respond_to? :tess_end)
    assert (TesseractFFI.respond_to? :set_image)
    assert (TesseractFFI.respond_to? :recognize)
    assert (TesseractFFI.respond_to? :pix_read)
    assert (TesseractFFI.respond_to? :get_utf8)
    assert (TesseractFFI.respond_to? :get_hocr)
    assert (TesseractFFI.respond_to? :set_rectangle)
    assert (TesseractFFI.respond_to? :set_source_resolution)
  end

  def test_recognizer_defaults
    recognizer = TesseractFFI::Recognizer.new
    assert recognizer
    assert_equal 'eng', recognizer.language
    assert_equal 'tesseractffi', recognizer.file_name
    assert_equal 72, recognizer.source_resolution
  end

  def test_recognizer_configuration
    recognizer = TesseractFFI::Recognizer.new(language:'deu', file_name: 'toto.png', source_resolution:96)
    assert recognizer
    assert_equal 'deu', recognizer.language
    assert_equal 'toto.png', recognizer.file_name
    assert_equal 96, recognizer.source_resolution
  end

  def test_recognizer_run_text
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:set_image).returns(TesseractFFI.set_image(@handle, @image))
    recognizer.expects(:set_source_resolution)
    recognizer.expects(:recognize).with(@handle, 0).returns(0)
    recognizer.expects(:get_utf8).with(@handle).returns('ABCD')
    recognizer.run
    TesseractFFI.tess_delete(@handle)
    assert_equal '', recognizer.errors
    assert_equal 'ABCD', recognizer.utf8_text
  end



  def test_recognizer_run_hocr
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:set_image).returns(TesseractFFI.set_image(@handle, @image))
    recognizer.expects(:set_source_resolution)
    recognizer.expects(:recognize).with(@handle, 0).returns(0)
    recognizer.expects(:get_hocr).with(@handle).returns('<html></html>')
    recognizer.run
    TesseractFFI.tess_delete(@handle)
    assert_equal '', recognizer.errors
    assert_equal '<html></html>', recognizer.hocr_text
  end



  def test_library_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.pix_read(@image_name)

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
    @image = TesseractFFI.pix_read(@image_name)
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
    @image = TesseractFFI.pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:set_image).returns(1) # error value
    assert_raises TesseractFFI::TessException do
      recognizer.run
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Unable to set image test/images/4words.png', recognizer.errors
  end


  def test_recognize_error
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng')

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:set_image).returns(TesseractFFI.set_image(@handle, @image))
    recognizer.expects(:set_source_resolution)
    recognizer.expects(:recognize).with(@handle, 0).returns(-1)
    # recognizer.expects(:get_utf8)
    assert_raises TesseractFFI::TessException do
      recognizer.run
    end
    TesseractFFI.tess_delete(@handle)
    assert_equal 'Tesseract Error Recognition Error', recognizer.errors
  end
end
