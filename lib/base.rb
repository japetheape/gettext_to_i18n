module GettextToI18n
  
  class Base
    attr_reader :translations
    LOCALE_DIR = RAILS_ROOT + '/config/locales/'
    STANDARD_LOCALE_FILE = LOCALE_DIR + 'template.yml'
    DEFAULT_LANGUAGE = 'some-LAN'

    def initialize
      @translations = {}
      transform_files!(Files.controller_files, :controller)
      transform_files!(Files.model_files, :model)
      transform_files!(Files.view_files, :view)
      transform_files!(Files.helper_files, :helper)
      transform_files!(Files.lib_files, :lib)
    end
    
    # Walks all files and converts them all to the new format
    def transform_files!(files, type)  
      files.each do |file|
        parsed = ""
        namespace = [DEFAULT_LANGUAGE, 'txt', type] + Base.get_namespace(file, type)
        puts "Converting: " + file + " into namespace: "
        puts namespace.map {|x| "[\"#{x}\"]"}.join("")
        
        n = Namespace.new(namespace)
        
        contents = Base.get_file_as_string(file)
        parsed << GettextI18nConvertor.string_to_i18n(contents, n)
  
        #puts parsed
        # write the file
        
        File.open(file, 'w') { |file| file.write(parsed)}
        
        
        
        n.merge(@translations)
      end
    end
    
    # Dumps the translation strings into config/locales/template.yml
    def dump_yaml!
      FileUtils.mkdir_p LOCALE_DIR
      File.open(STANDARD_LOCALE_FILE,'w+') { |f| YAML::dump(@translations, f) } 
    end
    
    
    private 
    
    
    def self.get_file_as_string(filename)
      data = ''
      f = File.open(filename, "r") 
      f.each_line do |line|
        data += line
      end
      return data
    end
    # returns a name for a file
    # example: 
    # Base.get_name('/controllers/apidoc_controller.rb', 'controller') => 'apidoc'
    def self.get_namespace(file, type)
     case type

       when :controller
         if result = /application\.rb/.match(file)
           return ['application']
         else
           result = /([a-zA-Z]+)_controller.rb/.match(file)
           return [result[1]]
         end
         return ""
       when :helper
         result = /([a-zA-Z]+)_helper.rb/.match(file)
         return [result[1]]
       when :model
          result = /([a-zA-Z]+).rb/.match(file)
          return [result[1]]
       when :view
         result = /views\/([\_a-zA-Z]+)\/([\_a-zA-Z]+).*\.([a-zA-Z]+)/.match(file)
         if result[3] != "erb"
           return [result[1], result[2], result[3]]
         else
           return [result[1], result[2]] 
         end
        when :lib
          result = /([a-zA-Z]+).rb/.match(file)
          return [result[1]]
     end
    end
    
  end
end