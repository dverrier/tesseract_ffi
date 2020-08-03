module TesseractFFI
  module ConfVars
    def get_double_variable(var_name)
      var_value = nil
      d_ptr = TesseractFFI::FFIDoublePtr.new

      result = tess_get_double_variable(@handle, var_name, d_ptr)
      if result 
        var_value = d_ptr[:value]
      else
        raise TessException.new(error_msg: 'Unable to get config variable ' + var_name)
      end
      var_value
    end

    def get_integer_variable(var_name)
      var_value = nil
      i_ptr = TesseractFFI::FFIIntPtr.new
      result = tess_get_int_variable(@handle, var_name, i_ptr)
      if result 
        var_value = i_ptr[:value]
      else
        raise TessException.new(error_msg: 'Unable to get config variable ' + var_name)
      end
      var_value
    end

    def set_variable(var_name, value)
      set_result = nil
      mem_ptr = FFI::MemoryPointer.from_string(value.to_s)
      result = tess_set_variable(@handle, var_name, mem_ptr)
      if result
        set_result = true
      else
        raise TessException.new(error_msg: 'Unable to set config variable ' + var_name)
      end
      set_result
    end

    def print_variables_to_file(file_name)
      result = tess_print_to_file(@handle, file_name)
      unless result
        raise TessException.new(error_msg: 'Unable to print variables to ' + file_name)
      end
      result
    end
  end
end