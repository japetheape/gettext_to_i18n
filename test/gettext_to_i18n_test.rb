require 'test/unit'
require File.dirname(__FILE__) + '/../init.rb'
require 'YAML'

class GettextToI18nTest < Test::Unit::TestCase
  def setup
    @c = GettextToI18n::Convertor.new(nil,nil,nil,nil)
  end
  def test_all_files
    files = GettextToI18n::Files.all_files
    assert_not_nil files, "no files available"
    assert files.size > 0
   end
   
   
  def test_controller_files
    files = GettextToI18n::Files.controller_files
    assert_not_nil files, "no files available"
    assert files.size > 0
  end
  
  
  def test_view_files
    files = GettextToI18n::Files.view_files
    assert_not_nil files, "no files available"
    assert files.size > 0
  end
  
  
  def test_helper_files
    files = GettextToI18n::Files.helper_files
    assert_not_nil files, "no files available"
    assert files.size > 0
  end
  
  def test_get_filename
    assert_equal 'apidoc', GettextToI18n::Convertor.get_name('/controllers/apidoc_controller.rb', :controller)
    assert_equal 'application', GettextToI18n::Convertor.get_name('/controllers/application.rb', :controller)
    assert_equal 'page', GettextToI18n::Convertor.get_name('/views/page/index.html.erb', :view)
  end
  
  
  
  def test_transform
    a = GettextToI18n::Base.new
    #puts a.dump_yaml
  end
  
  
  
  def test_get_vars
    assert_equal [['name', "'jaap'"]], @c.get_method_vars("\"hallo %{name}\" % {:name => 'jaap'}")
    assert_equal [['name', "vara"]], @c.get_method_vars("\"\" % {:name => vara}")
    assert_equal [['name', "\"jaap\""]], @c.get_method_vars("\"hallo %{name}\" % {:name => \"jaap\"}")
  end
  
  
  def test_i18n_convert
    assert_equal "t(:message1, :name => \"jaap\", :scope => [])", @c.construct_i18n_call('message1', "\"hallo %{name}\" % {:name => \"jaap\"}")
  end
  
  
  def test_line_transform
    convertor = GettextToI18n::Convertor.new('test', {}, :controller)  
    assert_equal "a", convertor.get_method_contents("_(a)")
    assert_equal "\"some translation\"", convertor.get_method_contents('_("some translation")')
    assert_equal '{"%{some}" % {:some => s}', convertor.get_method_contents('_({"%{some}" % {:some => s})')
    
    assert_nil convertor.get_method_contents('jes jes _(')
  end
  
end
