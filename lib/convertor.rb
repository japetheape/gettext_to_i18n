module GettextToI18n
  class Convertor
   
   GETTEXT_METHOD = /\_\(([\''\%\{\}\=\>\:a-zA-Z0-9 \"]*)\)/
   
   attr_reader :translations
   
   def initialize(file)
     @file = file
     
   end
   
   def transform!
     File.read(@file).each do |line|
       
       # check if there is a gettext method in this line
       # TODO multiple line methods
       if result = get_translation_and_id(line)
         
          add_translation(result[:id], result[:translation])
          # TODO change line
       end
     end
   end
   
   
  
   # Transforms the line from a gettext method to a i18n method
   # Adds the contents of the method to @translations and returns
   # a new i18n method. in the line
   def get_translation_and_id(line)
     
     if content = get_method_contents(line)
       translation = convert_method_contents(content)
       id = get_id(content)
       return {:id => id, :translation => translation}
     else
       return nil
     end
   end
   
   
   # Get the contents between the gettext method
   # Example: _('a') => \'a\'
   def get_method_contents(line)
     if result = GETTEXT_METHOD.match(line)
       return result[1]
     end
   end
   
   
   
   # generates an id for the content of the method
   def get_id(contents)
     number = @translations.nil? ? 0 : @translations.size
     return "message_%s" % number
   end
   
   # 
   def convert_method_contents(contents)
     return contents
   end
   
   
   
   # Add translation, id cannot be used twice
   def add_translation(id, translation)
     @translations = {} if @translations.nil?
     raise "translation already exists" unless @translations[id].nil?
     @translations[id] = translation
   end
 end
end