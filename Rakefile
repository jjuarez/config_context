begin
  require 'fileutils'
  require 'rake/runtest'
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


desc "Clean all temporary stuff..."
task :clean do
  
  begin
    FileUtils.remove_dir( File.join( File.dirname( __FILE__ ), 'pkg' ), true )
  rescue Exception => e
    fail( e.message )
  end
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


desc "Testing..."
task :test => [:clean, :build] do 
  
  Rake.run_tests 'test/unit/test_*.rb'
end


desc "The default task"
task :default=>[:test]