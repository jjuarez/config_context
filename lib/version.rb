module Version
  INFO = {
    :major =>0,
    :minor =>6,
    :patch =>1
  }

  NAME    = 'config_context'
  VERSION = [INFO[:major], INFO[:minor], INFO[:patch]].join( '.' )
end
