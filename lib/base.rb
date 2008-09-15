module GettextToI18n
  
  class Base
    attr_reader :translations
    
    def initialize
      @translations = {}
      transform_files!(Files.controller_files, :controller)
      transform_files!(Files.view_files, :view)
      transform_files!(Files.helper_files, :helper)
      puts @translations.to_yaml
    end
    
    
    def transform_files!(files, type)  
     
      files.each do |file|
        alternative_filename = Base.get_name(file, type)
        n = Namespace.new(['txt', type, alternative_filename])
        File.read(file).each do |line|
          
          tr_str = GettextI18nConvertor.string_to_i18n(line, n)
          
        end
        n.merge(@translations)
      end
    
      
    end
    
    
    
    
    def dump_yaml
      YAML::dump(@translations)
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