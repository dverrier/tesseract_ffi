# frozen_string_literal: true

module TesseractFFI
  # module Rectangles mixin for recognizing text blocks defined by rectangles
  module Rectangles
    def set_rectangle(x_coord, y_coord, width, height)
      tess_set_rectangle(@handle, x_coord, y_coord, width, height)
    end

    def recognize_rectangle(x_coord, y_coord, width, height)
      setup do
        set_rectangle(x_coord, y_coord, width, height)
        ocr
      end
    end

    # rubocop:disable Metrics/MethodLength
    def recognize_rectangles(rectangle_list)
      @texts = []
      @rectangle_list = nil
      if valid_rectangle_list? rectangle_list
        @rectangle_list = rectangle_list
        setup do
          @rectangle_list.each do |r|
            set_rectangle(r[0], r[1], r[2], r[3])
            ocr
            @texts << @utf8_text.strip
          end
        end
      end
      @texts
    end

    def valid_rectangle_list?(list)
      if list.is_a?(Array) && list.all? { |r| valid_rectangle?(r) }
        true
      else
        msg = 'Tess Error Argument must be a list'
        # copy the error message as we are not going to Setup
        @errors << msg
        raise TessException.new(error_msg: msg)
      end
    end

    def valid_rectangle?(rectangle)
      if rectangle.is_a?(Array) &&
         rectangle.length == 4 &&
         rectangle.all? { |r| r.is_a?(Integer) }
        true
      else
        msg = 'Tesseract Error Argument must be array of 4 Integer'
        @errors << msg
        raise TessException.new(error_msg: msg)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
