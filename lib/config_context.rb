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
  
  
  public
  def method_missing(method, *arguments, &block)
    
    @config ||= { }
    
    case method.to_s
      when /(.+)=$/  then @config[method.to_s.delete("=").to_sym] = arguments.length == 1 ? arguments[0] : arguments
      when /(.+)\?$/ then @config.keys.include?(method.to_s.delete("=?").to_sym)
    else

      if @config.keys.include?(method)
        @config[method]
      else 
        super
      end
    end    
  end
  
  def erase!()
    @config = { }
  end
  
  # def configure(*arguments, &block)
  # 
  #   @config ||= { }
  #   
  #   source = arguments[0]
  #   
  #   case source
  #     when /\.(yml|yaml)/i then @config.merge!(YAML.load_file(source)) rescue raise ConfigError.new("Problems loading the config file")
  #     when /\.json/i       then @config.merge!(JSON.parse(File.read(source))) rescue raise ConfigError.new("Problems loading the config file")
  #     when Hash            then @config.merge!(source)
  #     when Symbol          then @config[source.to_sym] = { }
  #   else yield self if block_given?
  #   end
  #   
  #   self
  # end

  def configure(source=nil, options={}, &block)

    @config ||= { }
    
    options = {:source=>nil, :context=>:root}.merge(options)
    
    if options[:context] == :root

      case source
        when /\.(yml|yaml)/i then @config.merge!(YAML.load_file(source)) rescue raise ConfigError.new("Problems loading file")
        when /\.json/i       then @config.merge!(JSON.parse(File.read(source))) rescue raise ConfigError.new("Problems loading file")
        when Hash            then @config.merge!(source)
      else 
        yield self if block_given?
      end
    else

      @config[options[:context]] ||= { }
      
      case source
        when /\.(yml|yaml)/i then @config[options[:context]].merge!(YAML.load_file(source)) rescue raise ConfigError.new("Problems loading file")
        when /\.json/i       then @config[options[:context]].merge!(JSON.parse(File.read(source))) rescue raise ConfigError.new("Problems loading file")
        when Hash            then @config[options[:context]].merge!(source)
      else 
        yield self if block_given?
      end
    end
    
    self
  end

  def to_hash 
    @config ||= { }
  end
    
  def to_s
    "#{@config.inspect}"
  end
  
  def inspect
    @config.inspect
  end
  
  ##
  # Backward compability...
  def [](key)
    @config ||= { } 
    @config[key]
  end
  
  deprecate :load, :configure
  deprecate :all,  :to_hash
end