require 'yaml'


module ConfigContext  
  class ConfigContextError < StandardError
  end
  
  class << self

    def init
      @config ||= Hash.new
    end
    
    def method_missing( method, *arguments, &block )
    
      init      
      if( method =~ /(.+)=$/)
      
        key          = method.to_s.delete( '=$' ).to_sym
        @config[key] = (arguments.length == 1) ? arguments[0] : arguments
      else
        return @config[method] if @config.keys.include?( method )
      end
    end
  
    def configure       
      yield self
    end

    def []( key )
      init  
      return @config[key] if @config[key]
      nil
    end
  
    def[]=( key, value )
      init
      @config[key]=value
    end
  
    def all
      init
      @config
    end

    def load( config_file )
      init
      yf = YAML.load_file( config_file )
      
      yf.keys.each do |key| 
        
        @config[key] = yf[key] 
      end
    rescue Exception => e
      raise ConfigContextError.new( e.message )
      nil
    else
      @config
    end
  end
end