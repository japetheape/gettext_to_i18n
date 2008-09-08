module GettextToI18n
  class Base
    attr_reader :translations
    
    def initialize
      @translations = {}
      
      transform_files!(Files.controller_files, :controller)
      transform_files!(Files.view_files, :view)
     
    end
    
    def transform_files!(files, type)
      namespace = type
      @translations[namespace] = {}
      
      
      files.each do |file|
        convertor = Convertor.new(file)
        convertor.transform!
        
        name = Base.get_name(file, type)
        
        unless @translations[namespace][name].nil?
          raise "Already defined namespace: #{namspace}.#{name}"
        end
        
        @translations[namespace][name.to_sym] = convertor.translations
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
        when :view
          result = /views\/([\_a-zA-Z]+)\//.match(file)
          return result[1]
          
      end
      
    end
    
  end
  
 
  
  
    
end