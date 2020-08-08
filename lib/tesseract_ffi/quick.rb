# frozen_string_literal: true

# module TesseractFFI Quick API
module TesseractFFI
  def self.to_text(file_name, language = 'eng')
    t = Tesseract.new(file_name: file_name, language: language)
    t.recognize
    t.utf8_text
  end

  def self.to_pdf(in_file_name, out_file_root)
    t = Tesseract.new(file_name: in_file_name)
    t.convert_to_pdf(out_file_root)
    t.utf8_text
  end
end
