require 'yaml'


module ConfigContext
  
  class ConfigContextError < StandardError; end
  
  class << self

    def method_missing( method, *arguments, &block )
      
      @config ||= {}
      
      if( method =~/(.+)=$/)
        
        key           = method.to_s.delete( '=$' ).to_sym
        @config[key] = (arguments.length == 1) ? arguments[0] : arguments
      else
        
        return @config[method] if @config.keys.include?( method )
      end
    end
    
    def configure       
      yield self
    end

    def []( key )

      @config ||= {}
      @config[key.to_sym] if @config
    end
    
    def[]=( key, value )

      @config ||= {}
      @config[key.to_sym] = value if @config
    end
    
    def all
      
      @config ||= {}
      @config
    end
  
    def load( config_file )

      @config ||= {}
      
      yaml_config = YAML.load_file( config_file )
      yaml_config.keys.each { |key| @config[key] = yaml_config[key] }
    rescue Exception => e
      raise ConfigContextError.new( e.message )
    else
      @config
    end
  end
end