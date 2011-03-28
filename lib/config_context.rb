require 'yaml'


module ConfigContext
  extend self
  
  @config = { }
  
  class Error < StandardError; end
  
  def method_missing( method, *arguments, &block )
  
    if( method.to_s =~ /(.+)=$/ )
    
      config_key          = method.to_s.delete( '=' ).to_sym
      @config[config_key] = (arguments.length == 1) ? arguments[0] : arguments
    elsif( method.to_s =~ /(.+)\?$/ )
      
      @config.has_key?( method.to_s.delete( '?' ).to_sym )
    else
      
      @config[method] if @config.has_key?( method )
    end
  end

  def configure; yield self; end

  def []( key ) return @config[key]; end

  def[]=( key, value ) @config[key] = value; end

  def all; @config; end
  
  def keys; @config.keys; end


  def load( config_file, options = { :allow_collisions => true } )
    
    if( options[:allow_collisions] )
      @config.merge!( YAML.load_file( config_file ) )
    else
      @config.merge!( YAML.load_file( config_file ) ) { |key, original_value, new_value| original_value }
    end
  rescue Exception => e
    raise ConfigContext::Error.new( e.message )
  end
end