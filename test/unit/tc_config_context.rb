$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. .. lib] ) )

require 'test/unit'
require 'config_context'


class TestLibraryFileName < Test::Unit::TestCase
  
  TEST_HASH = { :a=>'a', :b=>'b', :c=>'c' }
  TEST_FILE = "../fixtures/test.yml"
  
  def test_case_configure
    
    ConfigContext.configure do |config|
      config.a = "a"
      config.b = "b"
      config.c = "c"
    end
    
    assert_equal( ConfigContext.a, "a" )
    assert_equal( ConfigContext.b, "b" )
    assert_equal( ConfigContext.c, "c" )
  end

  def test_case_all
    
    ConfigContext.configure do |config|
      config.a = "a"
      config.b = "b"
      config.c = "c"
    end

    assert_equal( ConfigContext.all, TEST_HASH )
  end

  def test_case_hash
    
    ConfigContext.configure do |config|
      config[:a] = "a"
      config[:b] = "b"
      config[:c] = "c"
    end
    
    assert_equal( ConfigContext.a, "a" )
    assert_equal( ConfigContext.b, "b" )
    assert_equal( ConfigContext.c, "c" )

    assert_equal( ConfigContext[:a], "a" )
    assert_equal( ConfigContext[:b], "b" )
    assert_equal( ConfigContext[:c], "c" )
    
    assert_equal( ConfigContext.all, TEST_HASH )
  end

  def test_case_yaml
    
    ConfigContext.load( TEST_FILE )    
    assert_equal( ConfigContext.all, TEST_HASH )
  end
end