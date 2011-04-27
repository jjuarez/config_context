$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. .. lib] ) )


require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'config_context'


class TestConfigContext < Test::Unit::TestCase

  context "A ConfigContext" do

    TEST_SYMBOL      = 'symbol'
    TEST_LIST        = [1, 2, 3]
    TEST_HASH        = { :a=>1, :b=>2, :c=>3 }
    TEST_STRING      = 'string'
    TEST_OTHERSYMBOL = "othersymbol"
    
    
    setup do

      ConfigContext.configure do |config|

        config.mysymbol = TEST_SYMBOL
        config.mylist   = TEST_LIST
        config.myhash   = TEST_HASH
      end

      ConfigContext[TEST_STRING]  = TEST_STRING
      ConfigContext[:othersymbol] = TEST_OTHERSYMBOL
    end
    
    should "configure properties" do
    
      assert_equal( ConfigContext.mysymbol, TEST_SYMBOL )
      assert_equal( ConfigContext.mylist, TEST_LIST )
      assert_equal( ConfigContext.myhash, TEST_HASH )
      assert_equal( ConfigContext[TEST_STRING], TEST_STRING )
      assert_equal( ConfigContext.othersymbol, TEST_OTHERSYMBOL )
      assert_equal( ConfigContext[:othersymbol], TEST_OTHERSYMBOL )
    end

    should "check the presence of some properties" do
    
      assert( ConfigContext.mysymbol? )
      assert( ConfigContext.mylist? )
      assert( ConfigContext.myhash? )
      assert( ConfigContext.othersymbol? )

      assert( !ConfigContext.string? ) # Pay attention to this behaviour!!!

      assert( !ConfigContext.thisdonotexist? )
    end
    
    should "retrive all properties" do
     
      assert_equal( ConfigContext.all, { 
        :mysymbol    =>TEST_SYMBOL, 
        :mylist      =>TEST_LIST, 
        :myhash      =>TEST_HASH, 
        'string'     =>TEST_STRING,
        :othersymbol =>TEST_OTHERSYMBOL
      } )
    end
    
    should "retrieve all property keys" do

      [ :mysymbol, :mylist, :myhash, 'string', :othersymbol ].each do |key|
      
        assert( ConfigContext.keys.include?( key ) )
      end
    end

    should "load a Yaml file without keys collisions" do
          
      ConfigContext.load( File.join( File.dirname( __FILE__ ), %w[ .. fixtures test.yml] ) )    
      assert_equal( ConfigContext.all, { 
        :mysymbol    =>TEST_SYMBOL, 
        :mylist      =>TEST_LIST, 
        :myhash      =>TEST_HASH, 
        'string'     =>TEST_STRING,
        :othersymbol =>TEST_OTHERSYMBOL
      } )
    end
        
    should "load a Yaml file with key collisions" do
    
      original_value = "The Original value is here"
      
      ConfigContext.configure { |config| config.mysymbol = original_value }

      ConfigContext.load( File.join( File.dirname( __FILE__ ), %w[ .. fixtures test.yml] ), :allow_collisions=>false )    
      assert_equal( ConfigContext.all, { 
        :mysymbol    =>original_value, 
        :mylist      =>TEST_LIST, 
        :myhash      =>TEST_HASH, 
        'string'     =>TEST_STRING,
        :othersymbol =>TEST_OTHERSYMBOL
      } )
    end
    
    should "load a Yaml file with error" do
        
      assert_raises( ConfigContext::Error ) { ConfigContext.load( "very bad file.yml" ) }
    end
    
    should "update properties" do
      
      assert_equal( ConfigContext.mysymbol, TEST_SYMBOL )
      ConfigContext.mysymbol = "A"
      assert_equal( ConfigContext.mysymbol, "A" )

      assert_equal( ConfigContext.mylist, TEST_LIST )
      ConfigContext.mylist = [4,5,6]
      assert_equal( ConfigContext.mylist, [4,5,6] )

      assert_equal( ConfigContext.myhash, TEST_HASH )
      ConfigContext.myhash= { :d=>4, :e=>5, :f=>6 }
      assert_equal( ConfigContext.myhash, { :d=>4, :e=>5, :f=>6 } )
    end
  end
end