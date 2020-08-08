# frozen_string_literal: true

require 'helper'

class TestVariableGetSet < MiniTest::Test
  def setup
    @image_name = 'test/images/4words.png'
  end

  def test_get_double_variable
    var_name = 'language_model_penalty_non_dict_word'
    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.setup do
      var_value = tess.get_double_variable(var_name)
      assert_equal '0.15', var_value.to_s
      assert_equal [], tess.errors
    end
  end

  def test_set_double_variable
    var_name = 'language_model_penalty_non_dict_word'
    tess = TesseractFFI::Tesseract.new(file_name: @image_name)
    tess.setup do
      result = tess.set_variable(var_name, '0.2')
      assert result
      assert_equal [], tess.errors
    end
  end
end
