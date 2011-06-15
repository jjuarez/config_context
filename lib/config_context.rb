require 'yaml'


module ConfigContext
  extend self
  
  @config ||= {}
  
  class ConfigError < StandardError; end

  
  private
  def _add_property(property, *arguments)
    @config[property.to_s.delete("=?").to_sym] = arguments.length == 1 ? arguments[0] : arguments
  end
  
  def _exist_property?(property)
    @config.keys.include?(property.to_s.delete("=?").to_sym)
  end
  
  def _get_property(property)
    @config[property]
  end

  def self.deprecate(old_method, new_method) 

    define_method(old_method) do |*arguments, &block|
      
      warn("#{old_method}() is deprecated. Use #{new_method}() instead.")
      send(new_method, *arguments, &block)
    end 
  end
  
  
  public
  def method_missing(method, *arguments, &block)
    
    case method.to_s
      when /(.+)=$/  then _add_property(method, *arguments)
      when /(.+)\?$/ then _exist_property?(method)
    else
      _get_property(method)
    end
  end
  
  def configure(*arguments, &block)
   
    case arguments[0]
      when /\.(yml|yaml|conf|config)/i
        @config.merge!(YAML.load_file(arguments[0]))
      when Hash
        @config.merge!(arguments[0])
      else
        yield self if block_given?
    end
    
    self
  rescue StandardError=>e
    raise ConfigError.new(e.message)
  end

  def to_hash()
    @config
  end
  
  ##
  # Backward compability...
  def [](key)
    @config[key]
  end
  
  deprecate :load, :configure
  deprecate :all,  :to_hash
end