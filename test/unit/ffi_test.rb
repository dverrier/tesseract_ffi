# frozen_string_literal: true

require 'helper'

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
class TestFFI < MiniTest::Test
  def test_supported_api_methods
    assert(TesseractFFI.respond_to?(:version))
    assert(TesseractFFI.respond_to?(:tess_create))
    assert(TesseractFFI.respond_to?(:tess_delete))
    assert(TesseractFFI.respond_to?(:tess_init))
    assert(TesseractFFI.respond_to?(:tess_init3))
    assert(TesseractFFI.respond_to?(:tess_end))
    assert(TesseractFFI.respond_to?(:tess_set_image))
    assert(TesseractFFI.respond_to?(:tess_recognize))
    assert(TesseractFFI.respond_to?(:tess_pix_read))
    assert(TesseractFFI.respond_to?(:tess_get_utf8))
    assert(TesseractFFI.respond_to?(:tess_get_hocr))
    assert(TesseractFFI.respond_to?(:tess_set_rectangle))
    assert(TesseractFFI.respond_to?(:tess_set_source_resolution))
    assert(TesseractFFI.respond_to?(:tess_get_init_languages_as_string))

    assert(TesseractFFI.respond_to?(:tess_print_to_file))
    assert(TesseractFFI.respond_to?(:tess_get_int_variable))
    assert(TesseractFFI.respond_to?(:tess_get_double_variable))
    assert(TesseractFFI.respond_to?(:tess_set_variable))

    assert(TesseractFFI.respond_to?(:tess_get_oem))
    assert(TesseractFFI.respond_to?(:tess_get_datapath))
    assert(TesseractFFI.respond_to?(:tess_pdf_renderer_create))
    assert(TesseractFFI.respond_to?(:tess_process_pages))
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
