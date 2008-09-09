require 'test/unit'
require File.dirname(__FILE__) + '/../init.rb'
require 'YAML'

module GettextToI18n
  class GettextHelperTest < Test::Unit::TestCase
    
  
    def test_get_var_part
       line = "_(\"hallo %{name}\" % {:name => \"jaap\"})"
       result = GettextHelper.get_var_part(line)
       assert_equal ":name => \"jaap\"", result[1]
    end
   
    def test_get_vars
      assert_equal [['name', "'jaap'"]], GettextHelper.get_method_vars("\"hallo %{name}\" % {:name => 'jaap'}")
      assert_equal [['name', "vara"]], GettextHelper.get_method_vars("\"\" % {:name => vara}")
      assert_equal [['name', "\"jaap\""]], GettextHelper.get_method_vars("\"hallo %{name}\" % {:name => \"jaap\"}")
    end
  end
end