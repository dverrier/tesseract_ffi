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
    assert (TesseractFFI.respond_to? :tess_init3)
    assert (TesseractFFI.respond_to? :tess_end)
    assert (TesseractFFI.respond_to? :tess_set_image)
    assert (TesseractFFI.respond_to? :tess_recognize)
    assert (TesseractFFI.respond_to? :tess_pix_read)
    assert (TesseractFFI.respond_to? :tess_get_utf8)
    assert (TesseractFFI.respond_to? :tess_get_hocr)
    assert (TesseractFFI.respond_to? :tess_set_rectangle)
    assert (TesseractFFI.respond_to? :tess_set_source_resolution)
    assert (TesseractFFI.respond_to? :tess_get_init_languages_as_string)

    assert (TesseractFFI.respond_to? :tess_print_to_file)
    assert (TesseractFFI.respond_to? :tess_get_int_variable)
    assert (TesseractFFI.respond_to? :tess_get_double_variable)
    assert (TesseractFFI.respond_to? :tess_set_variable)

    assert (TesseractFFI.respond_to? :tess_get_oem)
    assert (TesseractFFI.respond_to? :tess_get_datapath)
    assert (TesseractFFI.respond_to? :tess_pdf_renderer_create)
    assert (TesseractFFI.respond_to? :tess_process_pages)
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
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng+lav',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    recognizer.expects(:tess_set_source_resolution)
    # recognizer.expects(:tess_recognize).with(@handle, 0).returns(0)
    recognizer.expects(:tess_get_utf8).with(@handle,0).returns('ABCD')
    assert_equal 'eng+lav', recognizer.tess_get_init_languages_as_string(@handle)
    recognizer.recognize
    TesseractFFI.tess_delete(@handle)
    assert_equal '', recognizer.errors
    assert_equal 'ABCD', recognizer.utf8_text
  end

  def test_recognizer_run_hocr
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng',3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    recognizer.expects(:tess_set_source_resolution)
    recognizer.expects(:tess_recognize).with(@handle, 0).returns(0)
    recognizer.expects(:tess_get_hocr).with(@handle,0).returns('<html></html>')
    recognizer.recognize
    TesseractFFI.tess_delete(@handle)
    assert_equal '', recognizer.errors
    assert_equal '<html></html>', recognizer.hocr_text
  end


  def test_recognizer_run_rectangle
    @handle = TesseractFFI.tess_create
    @image = TesseractFFI.tess_pix_read(@image_name)
    @init_result = TesseractFFI.tess_init(@handle, 0, 'eng', 3)

    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.expects(:tess_create).returns(@handle)
    recognizer.expects(:tess_delete).with(@handle)

    recognizer.expects(:tess_init).returns(@init_result)
    recognizer.expects(:tess_end).with(@handle)
    recognizer.expects(:tess_set_image).returns(TesseractFFI.tess_set_image(@handle, @image))
    recognizer.expects(:tess_set_source_resolution)
    recognizer.expects(:tess_recognize).with(@handle, 0).returns(0)
    recognizer.expects(:tess_set_rectangle).with(@handle,1,2,3,4)
    recognizer.expects(:tess_get_hocr).with(@handle,0).returns('<html></html>')

    recognizer.recognize_rectangle(1,2,3,4)
    TesseractFFI.tess_delete(@handle)
    assert_equal '', recognizer.errors
    assert_equal '<html></html>', recognizer.hocr_text
  end

  def test_get_double_variable
    var_name = 'language_model_penalty_non_dict_word'
    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.setup_tesseract do 
      var_value = recognizer.get_double_variable(var_name) 
      assert_equal '0.15', var_value.to_s
      assert_equal '', recognizer.errors
    end
  end

  def test_set_double_variable
    var_name = 'language_model_penalty_non_dict_word'
    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    recognizer.setup_tesseract do
      result = recognizer.set_variable(var_name, '0.2') 
      assert result
      assert_equal '', recognizer.errors
    end
  end

  def test_oem
    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name)
    assert_equal TesseractFFI::Default, recognizer.oem
    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name, oem: TesseractFFI::Legacy)
    assert_equal 0, recognizer.oem
    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name, oem: TesseractFFI::LTSM)
    assert_equal 1, recognizer.oem
    recognizer =  TesseractFFI::Recognizer.new(file_name: @image_name, oem: TesseractFFI::Legacy_LTSM)
    assert_equal 2, recognizer.oem
  end
end
