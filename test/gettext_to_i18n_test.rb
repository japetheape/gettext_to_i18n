require 'test/unit'
require File.dirname(__FILE__) + '/../init.rb'


class GettextToI18nTest < Test::Unit::TestCase
  
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
  
  
  
end
