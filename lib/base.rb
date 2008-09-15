module GettextToI18n
  
  class Base
    attr_reader :translations
    LOCALE_DIR = RAILS_ROOT + '/config/locales/'
    STANDARD_LOCALE_FILE = LOCALE_DIR + 'template.yml'
    DEFAULT_LANGUAGE = 'some-LAN'

    def initialize
      @translations = {}
      transform_files!(Files.controller_files, :controller)
      transform_files!(Files.view_files, :view)
      transform_files!(Files.helper_files, :helper)
      transform_files!(Files.lib_files, :lib)
    end
    
    # Walks all files and converts them all to the new format
    def transform_files!(files, type)  
      files.each do |file|
        parsed = ""
        alternative_filename = Base.get_name(file, type)
        n = Namespace.new([DEFAULT_LANGUAGE, 'txt', type, alternative_filename])
        
        File.read(file).each do |line|
          parsed << GettextI18nConvertor.string_to_i18n(line, n)
        end
        
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
        when :lib
          result = /([a-zA-Z]+).rb/.match(file)
          return result[1]
     end
    end
    
  end
end