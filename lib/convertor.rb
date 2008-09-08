module GettextToI18n
  class Convertor
   
   GETTEXT_METHOD = /\_\(([\''\%\{\}\=\>\:a-zA-Z0-9 \"]*)\)/
   GETTEXT_VARIABLES = /\%\{(\w+)\}*/
   attr_reader :translations
   
   def initialize(file, options = {})
     @file = file
     @options = options
   end
   
   def transform!
     File.read(@file).each do |line|
       
       # check if there is a gettext method in this line
       # TODO multiple line methods
       if result = get_translation_and_id(line)
          contents = convert_contents_to_i18n(result[:contents])
          if @options[:ask_for_identifiers]
            puts "#{@file}: Enter message id for #{result[:contents]}: [#{result[:id]}]"
            id = STDIN.gets.chomp
            unless id == ""
              add_translation(id, result[:contents])
            else
              add_translation(result[:id], result[:contents])
            end
          else
             add_translation(result[:id], contents)
          end
          
          # TODO change line
       end
     end
   end
   
   # Transforms the line from a gettext method to a i18n method
   # Adds the contents of the method to @translations and returns
   # a new i18n method. in the line
   def get_translation_and_id(line)
     if content = get_method_contents(line)
      
       vars = get_method_vars(line)
       id = get_id(content)
       return {:id => id, :vars => vars, :contents => content}
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
     return "message_%s" % (@translations.nil? ? 0 : @translations.size)
   end
   
  
   
   # convert the gettext method contents to an i18n content
   def get_method_vars(contents)
     if result = contents.scan(GETTEXT_VARIABLES)
       return result
     end
   end
   
   
   def convert_contents_to_i18n(contents)
    contents.gsub!(GETTEXT_VARIABLES, '[[\1]]')
    contents.gsub!(/^(\"|\')/, '')
    contents.gsub!(/(\"|\')$/, '')
    contents
   end
   
   # Add translation, id cannot be used twice
   def add_translation(id, translation)
     @translations = {} if @translations.nil?
     raise "translation already exists" unless @translations[id].nil?
     @translations[id] = translation
   end
 end
end