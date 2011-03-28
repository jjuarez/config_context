$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )


begin
  require 'version'
rescue LoadError => le
  fail( le.message )
end


task :clean do
  
  begin
    require 'fileutils'
    
    [ './tmp', './pkg' ].each { |dir| FileUtils.remove_dir( dir, true ) }
  rescue LoadError => le
    fail( "You need fileutils gem: #{e.message}" )
  end
end


task :build =>[:clean] do
  begin
    require 'jeweler'
  rescue LoadError => e
    fail "Jeweler not available. Install it with: gem install jeweler( #{e.message} )"
  end

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
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*rb' ]
  end

  Jeweler::GemcutterTasks.new
end


task :test => [:clean, :build] do 
  require 'rake/runtest'
  Rake.run_tests 'test/unit/tc_*.rb'
end


task :default=>[:test]
