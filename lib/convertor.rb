module GettextToI18n
  class Convertor
   
   GETTEXT_METHOD = /\_\(([\''\%\{\}\=\>\:a-zA-Z0-9 \"]*)\)/
 
  # GETTEXT_VARIABLE_CONTENTS = /:(\w+)[ *]\=\>[ *]([a-zA-Z\_\-\:\'\(\)\"\.\#]+)/
  
   
   
   attr_reader :translations
   
   def initialize(file, translations, type, options = {})
     @type = type
     @translations = translations
     @file = file
     @options = options
   end
   
   def transform!
     n = Namespace.new(@file)
     File.read(@file).each do |line|
        puts line
        tr_str = GettextI18nConvertor.string_to_i18n(line, n)
        puts tr_str
       
       
     end
   end
   

   
   private
   
   # returns a name for a file
   # example: 
   # Base.get_name('/controllers/apidoc_controller.rb', 'controller') => 'apidoc'
   def self.get_name(file, type)
     case type
       
       when :controller
         if result = /application\.rb/.match(file)
           return 'application'
         else
           result = /([a-zA-Z]+)_controller.rb/.match(file)
           return result[1]
         end
         return ""
       when :helper
         result = /([a-zA-Z]+)_helper.rb/.match(file)
         return result[1]
       when :view
         result = /views\/([\_a-zA-Z]+)\//.match(file)
         return result[1]
     end
   end
   
   
 end
end