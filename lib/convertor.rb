module GettextToI18n
  class Convertor
   
   GETTEXT_METHOD = /\_\(([\''\%\{\}\=\>\:a-zA-Z0-9 \"]*)\)/
   GETTEXT_VARIABLES = /\%\{(\w+)\}*/
   GETTEXT_VARIABLE_CONTENTS = /:(\w+)[ *]\=\>[ *]([a-zA-Z\_\-\:\'\"\.\#]+)/
   
   
   attr_reader :translations
   
   def initialize(file, translations, type, options = {})
     @type = type
     @translations = translations
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
          
          i18ncall = construct_i18n_call(result[:id], line)
          puts "-----------"
          
          puts line
          puts contents
          puts i18ncall
           
       end
     end
   end
   
   # Transforms the line from a gettext method to a i18n method
   # Adds the contents of the method to @translations and returns
   # a new i18n method. in the line
   def get_translation_and_id(line)
     if content = get_method_contents(line)
       id = get_id(content)
       return {:id => id, :contents => content}
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
     id = "message_%s" % (get_namespace.size)
     get_namespace.each do |i,v|
       id = i if v == contents
     end
     
     return id
   end
   
   
   def convert_contents_to_i18n(contents)
    contents.gsub!(GETTEXT_VARIABLES, '{{\1}}')
    contents.gsub!(/^(\"|\')/, '')
    contents.gsub!(/(\"|\')$/, '')
    contents
   end
   
   # Add translation, id cannot be used twice
   def add_translation(id, translation)
     get_namespace[id] = translation
   end
   
   
   def get_namespace
     file_name = Convertor.get_name(@file, @type)
     @translations[@type] = {} if @translations[@type].nil?
     @translations[@type][file_name] = {} if @translations[@type][file_name].nil?
     @translations[@type][file_name]
   end
   
   def get_namespace_i18n
     file_name = Convertor.get_name(@file, @type)
     "[:#{@type}, :#{file_name}]"
   end
   
    # convert the gettext method contents to an i18n content
    def get_method_vars(contents)
      
      if result = contents.scan(GETTEXT_VARIABLE_CONTENTS)
        return result
      end
    end
   
   # Constructs a I18n method call
   # I18n.translate :thanks, :name => 'Jeremy'
   # => "Thanks Jeremy"
   def construct_i18n_call(id, contents)
     vars = get_method_vars(contents)
     o = "t :#{id}"
     vars.each do |v|
       o << ", :#{v[0]} => #{v[1]}"
     end
     o << ", :scope => " + get_namespace_i18n
     o
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