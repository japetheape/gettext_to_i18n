module GettextToI18n
  class GettextHelper
    GETTEXT_VARIABLES = /\%\{(\w+)\}*/
     GETTEXT_VARIABLE_CONTENTS =/\{.*:(\w+)[ *]\=\>[ *]([a-zA-Z\_\-\:\'\(\)\"\.\#]+).*\}/
    # returns an array of methods
    def self.get_methods(str)
      
    end
    
    # Gets the part containing the vars
    # <%=_('sdfsdfsdf %{var1}' % {:var1 => 200} %/ %>
    # returns {:var1 => 200}
    def self.get_var_part(str)
      return /[\"|\'] *\%[ ]*\{(.*)\}[ ]*\)/.match(str)
    end

    
    # convert the gettext method contents to an i18n content
    def self.get_method_vars(contents)
     var_part = get_var_part(contents)
     if result = contents.scan(GETTEXT_VARIABLE_CONTENTS)
       return result 
     end
    end
     
     
  end
end