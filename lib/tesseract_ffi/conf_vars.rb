# frozen_string_literal: true

module TesseractFFI
  # module ConfVars
  module ConfVars
    def get_double_variable(var_name)
      d_ptr = TesseractFFI::FFIDoublePtr.new

      unless tess_get_double_variable(@handle, var_name, d_ptr)
        raise TessException.new(error_msg: 'Unable to get config variable ' + var_name)
      end

      d_ptr[:value]
    end

    def get_integer_variable(var_name)
      i_ptr = TesseractFFI::FFIIntPtr.new

      unless tess_get_int_variable(@handle, var_name, i_ptr)
        raise TessException.new(error_msg: 'Unable to get config variable ' + var_name)
      end

      i_ptr[:value]
    end

    def set_variable(var_name, value)
      mem_ptr = FFI::MemoryPointer.from_string(value.to_s)
      unless tess_set_variable(@handle, var_name, mem_ptr)
        raise TessException.new(error_msg: 'Unable to set config variable ' + var_name)
      end

      true
    end

    def print_variables_to_file(file_name)
      result = tess_print_to_file(@handle, file_name)
      raise TessException.new(error_msg: 'Unable to print variables to ' + file_name) unless result

      result
    end
  end
end
