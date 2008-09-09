module GettextToI18n
  class I18nHelper
    
    # Converts the gettext contents to i18n contents
    # It rewrites the variables
    def self.convert_contents(contents)
     contents.gsub!(GettextHelper::GETTEXT_VARIABLES, '{{\1}}')
     contents.gsub!(/^(\"|\')/, '')
     contents.gsub!(/(\"|\')$/, '')
     contents
    end
    
    
    # Constructs a I18n method call
     # I18n.translate :thanks, :name => 'Jeremy'
     # => "Thanks Jeremy"
    def self.construct_call(id, contents, namespace)
      vars = GettextHelper.get_method_vars(contents)
      o = "t(:#{id}"
      vars.each { |v| o << ", :#{v[0]} => #{v[1]}" }
      o + ", :scope => " + namespace + ")"
    end
    
    
    def self.get_namespace(arr = [])
      "[" + arr.collect {|v| ":#{v}"}.join(",") + "]"
      
       
     end
  end
end