$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. .. lib] ) )


require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'config_context'


class TestConfigContext < Test::Unit::TestCase

  context "A ConfigContext" do

    TEST_SYMBOL = 'symbol value'
    TEST_LIST   = [1, 2, 3]
    TEST_HASH   = { :a=>1, :b=>2, :c=>3 }
     
    setup do

      ConfigContext.configure do |config|
        config.mysymbol = TEST_SYMBOL
        config.mylist   = TEST_LIST
        config.myhash   = TEST_HASH
      end
    end
    
    should "configure properties" do
    
      assert_equal( ConfigContext.mysymbol, TEST_SYMBOL )
      assert_equal( ConfigContext.mylist, TEST_LIST )
      assert_equal( ConfigContext.myhash, TEST_HASH )
    end

    should "check the presence of some properties" do
    
      assert( ConfigContext.mysymbol? )
      assert( ConfigContext.mylist? )
      assert( ConfigContext.myhash? )

      assert( !ConfigContext.thisdonotexist? )
    end
    
    should "retrive all properties" do
     
      assert_equal( ConfigContext.all, { 
        :mysymbol =>TEST_SYMBOL, 
        :mylist   =>TEST_LIST, 
        :myhash   =>TEST_HASH
      } )
    end
    
    should "retrieve all property keys" do

      [ :mysymbol, :mylist, :myhash ].each do |key|
      
        assert( ConfigContext.all.keys.include?( key ) )
      end
    end

    should "load a Yaml file" do
          
      assert_raises( ConfigContext::Error ) { ConfigContext.load( "very_bad_file.yml" ) }
      ConfigContext.load( File.join( File.dirname( __FILE__ ), %w[ .. fixtures test.yml] ) )    
      assert_equal( ConfigContext.all, { 
        :mysymbol    =>TEST_SYMBOL, 
        :mylist      =>TEST_LIST, 
        :myhash      =>TEST_HASH 
      } )
    end
    
    should "update properties" do
      
      assert_equal( ConfigContext.mysymbol, TEST_SYMBOL )
      ConfigContext.mysymbol = "A"
      assert_equal( ConfigContext.mysymbol, "A" )

      new_test_list = [4,5,6]
      assert_equal( ConfigContext.mylist, TEST_LIST )
      ConfigContext.mylist = new_test_list
      assert_equal( ConfigContext.mylist, new_test_list )

      new_hash = { :d=>4, :e=>5, :f=>6 }
      assert_equal( ConfigContext.myhash, TEST_HASH )
      ConfigContext.myhash = new_hash
      assert_equal( ConfigContext.myhash, new_hash )
    end
  end
end