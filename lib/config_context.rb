require 'yaml'


module ConfigContext
  extend self
  
  class ConfigContextError < StandardError; end
  
  def init
    
    @config ||= {}
  end

  
  def method_missing( method, *arguments, &block )
  
    self.init unless @config
          
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
    
    self.init unless @config

    return @config[key] if @config[key]
    nil
  end


  def[]=( key, value )

    self.init unless @config

    @config[key]=value
  end


  def all
    
    self.init unless @config

    @config
  end


  def load( config_file )
    
    self.init unless @config

    yf = YAML.load_file( config_file )
    yf.keys.each { |key| @config[key] = yf[key] } 
  rescue Exception => e
    raise ConfigContextError.new( e.message )
  else
    @config
  end
end