$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )


begin
  require 'version'
rescue LoadError => le
  fail( 'You need to declare the NAME and the VERSION of your gem in lib/version.rb file (le.message)' )
end


task :clean do
  
  begin
    require 'fileutils'
    
    [ './tmp', './pkg', './coverage' ].each { |dir| FileUtils.remove_dir( dir, true ) }
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

    gemspec.name              = Version::NAME
    gemspec.version           = Version::INFO
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A Config Context for little applications'
    gemspec.description       = 'My config DSL'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*rb' ]
  end

  Jeweler::GemcutterTasks.new
end


task :test => [:clean, :build] do 
  require 'rake/runtest'
  Rake.run_tests 'test/unit/tc_*.rb'
end


task :publish => [:test] do
  begin
    require 'gemcutter'
    
    gem push "./pkg/#{Version::COMPLETE}.gem"    
  rescue LoadError => e
    fail( "gemcutter not available: #{e.message}" )
  end
end


task :metrics do

  begin
    require 'metric_fu'

    MetricFu::Configuration.run do |config|
      config.metrics  = [:churn, :saikuro, :stats, :flog, :flay]
      config.graphs   = [:flog, :flay, :stats]
    end
  rescue LoadError => e
    fail( "You need rcov gem: #{e.message}")
  end
end

task :default=>[:build]