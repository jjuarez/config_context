$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. .. lib] ) )


require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'config_context'


class TestConfigContext < Test::Unit::TestCase

  context "A ConfigContext" do

    setup do

      ConfigContext.configure do |config|

        config.element = "element"
        config.mylist    = [1,2,3]
        config.myhash    = { :a=>1, :b=>2, :c=>3 }
      end

      ConfigContext['string']  = "String"
      ConfigContext[:mysymbol] = "I am a pretty symbol"
    end
    
    should "Test configure members" do
    
      assert_equal( ConfigContext.element, "element" )
      assert_equal( ConfigContext.mylist, [1,2,3] )
      assert_equal( ConfigContext.myhash, { :a=>1, :b=>2, :c=>3 } )
      assert_equal( ConfigContext['string'], "String" )
      assert_equal( ConfigContext.mysymbol, "I am a pretty symbol" )
      assert_equal( ConfigContext[:mysymbol], "I am a pretty symbol" )
    end
  
    should "Test all properties" do
     
      assert_equal( ConfigContext.all, { 
        :element=>'element', 
        :mylist=>[1,2,3], 
        :myhash=>{ :a=>1, :b=>2, :c=>3 }, 
        :mysymbol=> 'I am a pretty symbol', 'string'=>'String' } )
    end

    should "Test yaml load without collisions" do
       
          
      ConfigContext.load( File.join( File.dirname( __FILE__ ), %w[ .. fixtures test.yml] ) )    
      assert_equal( ConfigContext.all, { 
        :element=>'element', 
        :mylist=>[1,2,3], 
        :myhash=>{ :a=>1, :b=>2, :c=>3 }, 
        :mysymbol=>'I am a pretty symbol', 'string'=>'String' } )
    end
        
    should "Test yaml load with collisions" do
    
      ConfigContext.configure do |config|
        config.element = 'first value'
      end

      ConfigContext.load( File.join( File.dirname( __FILE__ ), %w[ .. fixtures test.yml] ) )    
      assert_equal( ConfigContext.all, { 
        :element=>'first value', 
        :mylist=>[1,2,3], 
        :myhash=>{ :a=>1, :b=>2, :c=>3 }, 
        :mysymbol=>'I am a pretty symbol', 'string'=>'String' } )
    end
    
    should "Test yaml load with error in file" do
        
      assert_raises( ConfigContext::Error ) { ConfigContext.load( "very bad file.yml" ) }
    end
    
    should "Test update property" do
      
      assert_equal( ConfigContext.element, "element" )
      ConfigContext.element = "A"
      assert_equal( ConfigContext.element, "A" )

      assert_equal( ConfigContext.mylist, [1,2,3] )
      ConfigContext.mylist = [4,5,6]
      assert_equal( ConfigContext.mylist, [4,5,6] )

      assert_equal( ConfigContext.myhash, { :a=>1, :b=>2, :c=>3 } )
      ConfigContext.myhash= { :d=>4, :e=>5, :f=>6 }
      assert_equal( ConfigContext.myhash, { :d=>4, :e=>5, :f=>6 } )
    end
  end
end