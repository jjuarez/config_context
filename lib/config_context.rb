require 'yaml'


module ConfigContext
  extend self
  
  @config = { }
  
  class Error < StandardError; end
  
  def method_missing( method, *arguments, &block )
  
    if( method =~ /(.+)=$/)
    
      config_key          = method.to_s.delete( '=$' ).to_sym
      @config[config_key] = (arguments.length == 1) ? arguments[0] : arguments
    else
      return @config[method] if @config.keys.include?( method )
    end
  end


  def configure       
    
    yield self
  end


  def []( key )
    
    return @config[key]
  end


  def[]=( key, value )

    @config[key]=value
  end


  def all
    
    @config
  end


  def load( config_file )
    
    @config.merge!( YAML.load_file( config_file ) ) { |key, original_value, new_value| original_value }
  rescue Exception => e
    raise ConfigContext::Error.new( e.message )
  end
end