require 'helper'

class TestVariable < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
    @recognizer = TesseractFFI::Recognizer.new(file_name: @image_name)
  end


  def test_variable_get_set
    var_name = 'language_model_penalty_non_dict_word'
    desired_value = 0.2
    @recognizer.setup_tesseract do 
      old_value = @recognizer.get_double_variable(var_name)
      assert_equal 0.15, old_value

      result = @recognizer.set_variable(var_name, desired_value)
      assert result
      new_value = @recognizer.get_double_variable(var_name)
      assert_equal desired_value, new_value
    end
  end


end
