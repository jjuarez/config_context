require 'helper'
require 'config_context'


class TestConfigContext < Test::Unit::TestCase

  TEST_FILE_JSON = File.join(File.dirname(__FILE__), %w[fixtures test.json])
  TEST_FILE_YAML = File.join(File.dirname(__FILE__), %w[fixtures test.yml])
  TEST_SYMBOL    = 'symbol value'
  TEST_LIST      = [1, 2, 3]
  TEST_HASH      = { "a"=>1, "b"=>2, "c"=>3 }
   
  
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
  
  
 should "configure properties" do
  
    assert_equal(ConfigContext.mysymbol, TEST_SYMBOL)
    assert_equal(ConfigContext.mylist, TEST_LIST)
    assert_equal(ConfigContext.myhash, TEST_HASH)
    assert_equal(ConfigContext.mysymbol, ConfigContext[:mysymbol])
  end


 should "check the presence of some properties" do
  
    assert(ConfigContext.mysymbol?)
    assert(ConfigContext.mylist?)
    assert(ConfigContext.myhash?)
    assert(!ConfigContext.thisdonotexist?)
  end

  
 should "retrive all properties" do
   
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH
    })
  end


 should "retrive all properties with defaults" do
   
    assert(!ConfigContext.fetch(:mysymbol_))

    assert_equal(ConfigContext.fetch(:mysymbol,  "default value"), "symbol value")
    assert_equal(ConfigContext.fetch(:mysymbol_, "default value"), "default value")
    assert_equal(ConfigContext.fetch(:mysymbol_, [1,2,3]), [1,2,3])
    assert_equal(ConfigContext.fetch(:mysymbol_, {:a=>'a', :b=>'b'}), {:a=>'a', :b=>'b'})
    
    assert_equal(ConfigContext.fetch!(:mysymbol_, "default value"), "default value")    
    assert_equal(ConfigContext.fetch!(:mysymbol_, "new value"), "default value")    
  end

  
 should "retrieve all property keys" do

    [:mysymbol, :mylist, :myhash].each do |key|
    
      assert(ConfigContext.to_hash.keys.include?(key))
    end
  end

 should "update properties" do
    
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


 should "configure from a hash" do
    
    config_hash = { 
      :mysymbol =>TEST_SYMBOL, 
      :mylist   =>TEST_LIST, 
      :myhash   =>TEST_HASH 
    }
    
    ConfigContext.configure(config_hash)
    assert_equal(ConfigContext.to_hash, config_hash)
  end

  
 should "configuration from a file that not exist" do
  
    ['json', 'yaml', 'yml'].each do |extension|
    
      assert_raises(ConfigContext::ConfigError) { ConfigContext.configure("this_file_do_not_exist.#{extension}") }
    end
  end

  
 should "configuration from a bad format file" do
  
    ['foo', 'bar', 'bazz'].each do |extension|
    
      assert_equal(ConfigContext.configure("this_file_do_not_exist.#{extension}").to_hash, {
        :mysymbol =>TEST_SYMBOL, 
        :mylist   =>TEST_LIST, 
        :myhash   =>TEST_HASH 
        })
    end
    
    ConfigContext.erase!
    
    ['foo', 'bar', 'bazz'].each do |extension|
    
      assert_equal(ConfigContext.configure("this_file_do_not_exist.#{extension}").to_hash, {})
    end
  end

  
 should "configure from a yaml file" do
        
    ConfigContext.configure(TEST_FILE_YAML)    
    assert_equal(ConfigContext.to_hash, { 
      :mysymbol  =>TEST_SYMBOL, 
      :mylist    =>TEST_LIST, 
      :myhash    =>TEST_HASH, 
      "mysymbol" =>TEST_SYMBOL, 
      "mylist"   =>TEST_LIST, 
      "myhash"   =>TEST_HASH
    })
  end

  
 should "configure from a yaml file in a context" do
        
    ConfigContext.configure(TEST_FILE_YAML, :context=>:yaml)

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
    
    assert_equal(ConfigContext.yaml, { 
      "mysymbol" =>TEST_SYMBOL, 
      "mylist"   =>TEST_LIST, 
      "myhash"   =>TEST_HASH
    })
  end


 should "configure from a json file" do
        
    ConfigContext.configure(TEST_FILE_JSON)    

    assert_equal(ConfigContext.to_hash, { 
      :mysymbol  =>TEST_SYMBOL, 
      :mylist    =>TEST_LIST, 
      :myhash    =>TEST_HASH, 
      "mysymbol" =>TEST_SYMBOL, 
      "mylist"   =>TEST_LIST, 
      "myhash"   =>TEST_HASH
    })
  end


 should "configure from a json file in a context" do
        
    ConfigContext.configure(TEST_FILE_JSON, :context=>:json)    
    
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
    
    assert_equal(ConfigContext.json, { 
      "mysymbol" =>TEST_SYMBOL, 
      "mylist"   =>TEST_LIST, 
      "myhash"   =>TEST_HASH
    })
  end
end
