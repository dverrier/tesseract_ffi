require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

Rake::TestTask.new(:test_system) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/system/*_test.rb'
  test.verbose = true
end

Rake::TestTask.new(:test_units) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/unit/*_test.rb'
  test.verbose = true
end

task :default => :test


