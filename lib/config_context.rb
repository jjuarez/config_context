require 'yaml'


module ConfigContext
  extend self
  
  @config = { }
  
  class Error < StandardError; end
  
  
  private
  
  
  def _method_to_key( method )
    method.to_s.delete( '=?!' ).to_sym
  end
  
  def _add_property( method, *arguments )
    @config[_method_to_key( method )] = arguments.length == 1 ? arguments[0] : arguments
  end
  
  def _property?( method )
    @config.keys.include?( _method_to_key( method ) )
  end
  
  def _get_property( method )
    @config[method]
  end

  def configure_from_hash( hash )
    @config.merge!( hash )
  end

  def configure_from_yaml( config_file )

    YAML.load_file( config_file ).each { |k, v| @config[k] = v }
  rescue Exception => e
    raise ConfigContext::Error.new( e.message )
  end  

  def self.deprecate( old_method, new_method ) 

    define_method( old_method ) do |*arguments, &block|
      
      warn( "Warning: #{old_method}() is deprecated. Use #{new_method}() instead." )
      send( new_method, *arguments, &block )
    end 
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
    
    case arguments[0]
      when /\.(yml|yaml)/i
        configure_from_yaml( arguments[0] )
      when Hash
        configure_from_hash( arguments[0] )
      else
        yield self if block_given?
      end
  end

  def to_hash()
    @config
  end
  
  deprecate :load, :configure
  deprecate :all,  :to_hash
end