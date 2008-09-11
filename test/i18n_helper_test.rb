require 'test/unit'
require File.dirname(__FILE__) + '/../init.rb'
require 'YAML'

module GettextToI18n
  class I18nHelperTest < Test::Unit::TestCase
    
    def test_i18n_convert
      i18n_namespace = I18nHelper.get_namespace()
      assert_equal "t(:message1, :name => \"jaap\", :scope => [])", I18nHelper.construct_call('message1', "\"hallo %{name}\" % {:name => \"jaap\"}",i18n_namespace)
    end
  
  
  end
end