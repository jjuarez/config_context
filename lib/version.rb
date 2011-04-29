module Version
  INFO = {
    :major =>0,
    :minor =>3,
    :patch =>5
  }

  NAME    = 'config_context'
  VERSION = [INFO[:major], INFO[:minor], INFO[:patch]].join( '.' )
end