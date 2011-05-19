require 'yaml'


module ConfigContext
  extend self
  
  @config = {}
  
  class Error < StandardError; end
  
  private
  def _add_property( method, *arguments )
    
    property_key          = method.to_s.delete( '=' ).to_sym
    @config[property_key] = arguments.length == 1 ? arguments[0] : arguments
  end
  
  def _property?( method )
    
    property_key = method.to_s.delete( '?' ).to_sym
    @config.keys.include?( property_key )
  end
  
  def _get_property( method )
    @config[method]
  end

  def configure_from_yaml( config_file ) 

    YAML.load_file( config_file ).each do |key,value|
      
      @config[key] = value
    end
  rescue Exception => e
    raise ConfigContext::Error.new( e.message )
  end
  
  
  public  
  def method_missing( method, *arguments, &block )
    
    if( method.to_s =~ /(.+)=$/ )
      _add_property( method, *arguments )
    elsif( method.to_s =~ /(.+)\?$/ )
      _property?( method )
    else
      _get_property( method )
    end
  end
  
  def configure( *arguments, &block )
    
    configuration = case arguments[0]
      when /\.(yml|yaml)/i
        configure_from_yaml( arguments[0] )
      else
        yield self if block_given?
      end
  end

  def to_hash()
    @config
  end

  # Backward compat with older versions
  alias :load :configure
  alias :all :to_hash
end