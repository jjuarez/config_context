# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|

  gem.name        = "config_context"
  gem.homepage    = "http://github.com/jjuarez/config_context"
  gem.license     = "MIT"
  gem.summary     = %Q{My configuration DSL}
  gem.description = %Q{A library for help to configure applications}
  gem.email       = "javier.juarez@gmail.com"
  gem.authors     = ["Javier Juarez"]

end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
