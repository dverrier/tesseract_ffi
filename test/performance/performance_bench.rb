require 'helper'

class PerformanceBench < Minitest::Benchmark

  def self.bench_range
    # bench_exp 10, 10_000
    # linear start, stop,step
    bench_linear 2, 20, 4
  end

  def setup    
    @file_name = 'test/images/multitext.png'
    @rectangles = [
      #  x,   y,   w,   h
      [ 30,  90, 200, 100], #Ten
      [ 30, 180, 200, 100], #Eleven
      [ 30, 290, 200, 100], #Twelve
      [ 30, 450, 200, 100], #Thirteen
      [ 30, 600, 200, 100], #Fourteen
      [350,  90, 300, 100], #Twenty
      [350, 400, 300, 100], #Thirty-two
      [350, 500, 300, 100]] #Forty
    @texts =['Ten','Eleven','Twelve','Thirteen','Fourteen','Twenty','Thirty-two','Forty']
  end

  def bench_tessffi
    tess =TesseractFFI::Tesseract.new(file_name: @file_name)
    assert_performance_linear 0.99 do |n|
      n.times do
        @recognized_texts = []
        @recognized_texts = tess.recognize_rectangles(@rectangles)
        assert_equal @texts, @recognized_texts
      end
    end
  end
end
