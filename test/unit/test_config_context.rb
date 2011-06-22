$:.unshift(File.join(File.dirname(__FILE__), %w[.. .. lib]))


require 'rubygems'
require 'test/unit'
require 'config_context'


class TestConfigContext < Test::Unit::TestCase

  TEST_SYMBOL = 'symbol value'
  TEST_LIST   = [1, 2, 3]
  TEST_HASH   = { "a"=>1, "b"=>2, "c"=>3 }
   
   
  def setup

    ConfigContext.configure do |config|
            
      config.mysymbol = TEST_SYMBOL
      config.mylist   = TEST_LIST
      config.myhash   = TEST_HASH
    end
  end
  
  
  def teardown
    
    ConfigContext.erase!
  end
  
  def test_configure_properties
  
    assert_equal(ConfigContext.mysymbol, TEST_SYMBOL)
    assert_equal(ConfigContext.mylist, TEST_LIST)
    assert_equal(ConfigContext.myhash, TEST_HASH)
    assert_equal(ConfigContext.mysymbol, ConfigContext[:mysymbol])
  end

  def test_check_the_presence_of_some_properties
  
    assert(ConfigContext.mysymbol?)
    assert(ConfigContext.mylist?)
    assert(ConfigContext.myhash?)
    assert(!ConfigContext.thisdonotexist?)
  end
  
  def test_retrive_all_properties
   
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH
    })
  end
  
  def test_retrieve_all_property_keys

    [:mysymbol, :mylist, :myhash].each do |key|
    
      assert(ConfigContext.to_hash.keys.include?(key))
    end
  end

  def test_update_properties
    
    assert_equal(ConfigContext.mysymbol, TEST_SYMBOL)
    ConfigContext.mysymbol = "A"
    assert_equal(ConfigContext.mysymbol, "A")

    new_test_list = [4,5,6]
    assert_equal(ConfigContext.mylist, TEST_LIST)
    ConfigContext.mylist = new_test_list
    assert_equal(ConfigContext.mylist, new_test_list)

    new_hash = { :d=>4, :e=>5, :f=>6 }
    assert_equal(ConfigContext.myhash, TEST_HASH)
    ConfigContext.myhash = new_hash
    assert_equal(ConfigContext.myhash, new_hash)
  end

  def test_configure_from_a_hash
    
    config_hash = { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH 
    }
    
    ConfigContext.configure(config_hash)
    assert_equal(ConfigContext.to_hash, config_hash)
  end
  
  def test_configuration_from_a_file_that_not_exist
  
    ['json', 'yaml', 'yml'].each do |extension|
    
      assert_raises(ConfigContext::ConfigError) { ConfigContext.configure("this_file_do_not_exist.#{extension}") }
    end
  end
  
  def test_configuration_from_a_bad_format_file
  
    ['foo', 'bar', 'bazz'].each do |extension|
    
      assert_equal(ConfigContext.configure("this_file_do_not_exist.#{extension}").to_hash, {
        :mysymbol =>TEST_SYMBOL, 
        :mylist   =>TEST_LIST, 
        :myhash   =>TEST_HASH 
        })
    end
  end
  
  def test_configure_from_a_yaml_file
        
    ConfigContext.configure(File.join(File.dirname(__FILE__), %w[ .. fixtures test.yml]))    
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH, 
      "mysymbol" =>TEST_SYMBOL, 
      "mylist"   =>TEST_LIST, 
      "myhash"   =>TEST_HASH
    })
  end
  
  def test_configure_from_a_yaml_file_in_a_context
        
    ConfigContext.configure(File.join(File.dirname(__FILE__), %w[ .. fixtures test.yml]), :context=>:yaml)
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH,
      :yaml=>{
        "mysymbol" =>TEST_SYMBOL, 
        "mylist"   =>TEST_LIST, 
        "myhash"   =>TEST_HASH
      }
    })
  end

  def test_configure_from_a_json_file
        
    ConfigContext.configure(File.join(File.dirname(__FILE__), %w[ .. fixtures test.json]))    
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH, 
      "mysymbol" =>TEST_SYMBOL, 
      "mylist"   =>TEST_LIST, 
      "myhash"   =>TEST_HASH
    })
  end

  def test_configure_from_a_json_file_in_a_context
        
    ConfigContext.configure(File.join(File.dirname(__FILE__), %w[ .. fixtures test.json]), :context=>:json)    
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH, 
      :json=>{
        "mysymbol" =>TEST_SYMBOL, 
        "mylist"   =>TEST_LIST, 
        "myhash"   =>TEST_HASH
      }
    })
  end
end