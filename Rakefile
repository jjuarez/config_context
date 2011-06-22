begin
  require 'rake'
  require 'rake/testtask'
  require 'fileutils'
  require 'jeweler'
    
rescue LoadError => le
  fail( le.message )
end


$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )

begin
  require 'version'
rescue LoadError => le
  fail( "You must declare version information in lib/version.rb file (#{le.message})" )
end


desc "Clean all temporary stuff"
task :clean do

  require 'fileutils'
      
  [ "coverage", "coverage.data", "pkg" ].each { |fd| FileUtils.rm_rf( fd ) } 
end


desc "Build the gem..."
task :build =>:clean do

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = ConfigContext::Version::NAME
    gemspec.version           = ConfigContext::Version::VERSION
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{ConfigContext::Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A Config Context for little applications'
    gemspec.description       = 'My config DSL'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{ConfigContext::Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*.rb' ]

    gemspec.add_runtime_dependency 'json'
  end
end


desc "Measures unit test coverage"
task :coverage=>:clean do

  INCLUDE_DIRECTORIES = "lib:test"

  def run_coverage( files )

    fail( "No files were specified for testing" ) if files.length == 0
    sh "rcov --include #{INCLUDE_DIRECTORIES} --exclude gems/*,rubygems/* --sort coverage --aggregate coverage.data #{files.join( ' ' )}"
  end

  run_coverage Dir["test/**/*.rb"]
end

desc 'Test all this stuff'
Rake::TestTask.new(:test) do |test|

  test.libs << 'lib'
  test.libs << 'test'

  test.pattern = 'test/**/test_*.rb'
  test.verbose = false
end


desc "The default task"
task :default=>:test
