require 'test/unit'
require File.dirname(__FILE__) + '/../init.rb'
require 'YAML'

module GettextToI18n
  class GettextI18nTest < Test::Unit::TestCase
    
   
    
    def test_other_string
      assert_equal 'a   ', GettextI18nConvertor.new("_('a   ')").contents
      assert_equal 'a   ', GettextI18nConvertor.new("_('a   ' % {:a => 'sdasd'})").contents
      assert_equal ":a => 'sdasd'", GettextI18nConvertor.new("_('a   ' % {:a => 'sdasd'})").variable_part
    end
  
  
    def test_variables
      assert_equal ":a => 'sdasd', :b => 'sdasd'", GettextI18nConvertor.new("_('a   ' % {:a => 'sdasd', :b => 'sdasd'})").variable_part
      assert_equal [{:name => "a", :value => "'sdasd'"}, {:name => "b", :value => "'sdasd'"}], GettextI18nConvertor.new("_('a   ' % {:a => 'sdasd', :b => 'sdasd'})").variables
      assert_equal "t(:message_0, :a => 'sdasd')", GettextI18nConvertor.new("_('a   ' % {:a => 'sdasd'})", Namespace.new("somenamespace")).to_i18n
      assert_equal "t(:message_0, :a => 'sdasd', :b => 'sd')", GettextI18nConvertor.new("_('a   ' % {:a => 'sdasd', :b => 'sd'})", Namespace.new("somenamespace")).to_i18n
      assert_equal ":a => 'sdf' + _(sdf)", GettextI18nConvertor.new("_('aaa' % {:a => 'sdf' + _(sdf)}) %>", Namespace.new("somenamespace")).variable_part
    end
    
    def test_multiple_variables
      assert_equal "<%=t(:message_0, :a => 'sdf', :b => 'agh') %>", GettextI18nConvertor.string_to_i18n("<%=_('aaa' % {:a => 'sdf', :b => 'agh'}) %>", Namespace.new("somenamespace")) 
    end
    
    
    def test_recursive_gettext
      t = GettextI18nConvertor.new("<%=_('aaa' % {:a => 'sdf' + _(sdfg) + _(sdfg), :b => '21'}) %>", Namespace.new("somenamespace"))
      assert_equal ":a => 'sdf' + _(sdfg) + _(sdfg), :b => '21'", t.variable_part
      assert_equal [{:value=>"'sdf' + t(:message_0) + t(:message_1)", :name=>"a"},  {:value=>"'21'", :name=>"b"}], t.variables
      
      assert_equal "<%=t(:message_0, :a => 'sdf' + t(:message_1) + t(:message_2)) %>", GettextI18nConvertor.string_to_i18n("<%=_('aaa' % {:a => 'sdf' + _(sdfg) + _(sdfg)}) %>", Namespace.new("somenamespace")) 
    
    end
    
    
    def test_variable_parts
      assert_equal "t(:message_0, :a => 'sdasddd', :b => 'sdasd' + t(:message_1))" , GettextI18nConvertor.new("_('a   ' % {:a => 'sdasddd', :b => 'sdasd' + _('sfd')})", Namespace.new("somenamespace")).to_i18n
    end
    
    
    def test_exceptions
      str = "<%=_(\"Invoice: %{desc}\" % {:desc => @invoice.description}) %>"
      t = GettextI18nConvertor.new(str, Namespace.new("some"))
      
      
      str = "_(\"Information about advertising will soon follow, in the mean time, %{contact}.\" % {:contact => link_to(_(\"please contact us\"), contact_path)})"
      t = GettextI18nConvertor.new(str, Namespace.new("some"))
      assert_equal ":contact => link_to(_(\"please contact us\"), contact_path)", t.variable_part
      assert_equal [{:value=>"link_to(t(:message_0), contact_path)", :name=>"contact"}], t.variables
      
    end
    
    
    def test_greedyness
      str = "_(\"%{project_name} (copy)\") % {:project_name => @project.name}"
      t= GettextI18nConvertor.string_to_i18n(str, Namespace.new('d'))
      puts t
      
      r = GettextI18nConvertor.new(str, Namespace.new('sdf'))
      puts r.contents
      puts r.variable_part
     

      
    end
    
    
    def test_sime

       str = " <%=_('Pay per %{period}' % {:period => pv.period}) %> (<%=show_price(pv.price.convert_to(default_currency).get_rounded_on(Membership::ROUND_PRICES_ON_CENTS), pv.price.convert_to(default_currency).currency) %> / <%=pv.period %>). <br />"
       puts GettextI18nConvertor.string_to_i18n(str, Namespace.new('d'))
       
       
       
    end
  end
end