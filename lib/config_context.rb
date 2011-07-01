require 'yaml'
require 'json'


module ConfigContext
  extend self
  
  class ConfigError < StandardError; end

  private
  def self.deprecate(old_method, new_method) 

    define_method(old_method) do |*arguments, &block|
      
      warn("#{old_method}() is deprecated. Use #{new_method}() instead.")
      send(new_method, *arguments, &block)
    end 
  end

  def init
    @config ||= Hash.new
  end
  
  public
  def method_missing(method, *arguments, &block)
    
    @config || init
    
    case method.to_s
      when /(.+)=$/  then
        property_key = method.to_s.delete('=').to_sym
        
        @config[property_key] = (arguments.size == 1) ? arguments[0] : arguments
      
      when /(.+)\?$/ then 
        property_key = method.to_s.delete('?').to_sym

        @config.keys.include?(property_key) #true/false
    else

      if @config.keys.include?(method) # any type
        @config[method]
     else
        super
      end
    end    
  end
  
  def erase!()
    @config = Hash.new
  end
  
  def configure(source=nil, options={}, &block)

    @config || init
    
    options = {:source=>nil, :context=>:root}.merge(options)
    
    if options[:context] == :root

      case source
        when /\.(yml|yaml)/i then @config.merge!(YAML.load_file(source)) rescue raise ConfigError.new("Problems loading file: #{source}")
        when /\.json/i       then @config.merge!(JSON.parse(File.read(source))) rescue raise ConfigError.new("Problems loading file: #{source}")
        when Hash            then @config.merge!(source)
      else 
        yield self if block_given?
      end
    else

      context          = options[:context]
      @config[context] ||= { } # New context
      
      case source
        when /\.(yml|yaml)/i then @config[context].merge!(YAML.load_file(source)) rescue raise ConfigError.new("Problems loading file: #{source}")
        when /\.json/i       then @config[context].merge!(JSON.parse(File.read(source))) rescue raise ConfigError.new("Problems loading file: #{source}")
        when Hash            then @config[context].merge!(source)
      else 
        yield self if block_given?
      end
    end
    
    self
  end

  def to_hash 
    @config || init
  end
    
  def inspect
    
    @config || init
    @config.inspect
  end

  def to_s
    "#{@config.inspect}"
  end  
  
  ##
  # Backward compability...
  def [](key)
    
    @config || init 
    @config[key]
  end
  
  def fetch(key,default=nil)
    
    @config || init
    if @config.include?(key)
      
      @config[key]
    else
      default ? default : nil
    end 
  end
  
  deprecate :load, :configure
  deprecate :all,  :to_hash
end