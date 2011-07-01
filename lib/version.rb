module ConfigContext
  class Version
    
    INFO = {
      :major =>0,
      :minor =>7,
      :patch =>4
    }
    
    def self.number(version_info=INFO)

      if RUBY_VERSION =~ /1\.8\.\d/
        [version_info[:major], version_info[:minor],version_info[:patch]].join('.')
      else
        version_info.values.join('.')
      end
    end
    

    NAME    = 'config_context'
    NUMBER  = "#{number()}"
    VERSION = [INFO[:major], INFO[:minor], INFO[:patch]].join( '.' )
  end
end
