begin
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
task :build =>[:clean] do

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = Version::NAME
    gemspec.version           = Version::VERSION
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A Config Context for little applications'
    gemspec.description       = 'My config DSL'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*.rb' ]
  end
end


desc "Measures unit test coverage"
task :coverage=>[:clean] do

  INCLUDE_DIRECTORIES = "lib:test"

  def run_coverage( files )

    fail( "No files were specified for testing" ) if files.length == 0
    sh "rcov --include #{INCLUDE_DIRECTORIES} --exclude gems/*,rubygems/* --sort coverage --aggregate coverage.data #{files.join( ' ' )}"
  end

  run_coverage Dir["test/**/*.rb"]
end


desc "Testing..."
task :test=>[:build, :coverage] do 
  require 'rake/runtest'
  
  Rake.run_tests 'test/unit/test_*.rb'
end


desc "The default task"
task :default=>[:test]
