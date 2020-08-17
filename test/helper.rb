# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'unit tests', 'test/unit'
  add_group 'system tests', 'test/system'
  add_group 'lib', 'lib/'
end

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'minitest'
require 'minitest/autorun'
require "minitest/benchmark"

require 'mocha/minitest'
require 'tesseract_ffi'
require 'ap'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
