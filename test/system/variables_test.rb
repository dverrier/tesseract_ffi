require 'helper'

class TestVariable < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    @tess = TesseractFFI::Tesseract.new(file_name: @image_name)
  end


  def test_variable_get_set
    var_name = 'language_model_penalty_non_dict_word'
    desired_value = 0.2
    @tess.setup do 
      old_value = @tess.get_double_variable(var_name)
      assert_equal 0.15, old_value

      result = @tess.set_variable(var_name, desired_value)
      assert result
      new_value = @tess.get_double_variable(var_name)
      assert_equal desired_value, new_value
    end
  end


  def test_variable_get_set_int
    var_name = 'editor_image_xpos'
    desired_value = 591
    @tess.setup do 
      old_value = @tess.get_integer_variable(var_name)
      assert_equal 590, old_value

      result = @tess.set_variable(var_name, desired_value)
      assert result
      new_value = @tess.get_integer_variable(var_name)
      assert_equal desired_value, new_value
    end
  end

  def test_print_variables
    file_name = 'tmp/print.txt'
    File.delete(file_name) if File.exist? file_name
    @tess.setup do 
      @tess.print_variables_to_file file_name
      assert File.exist? file_name
    end
    File.delete file_name
  end

end
