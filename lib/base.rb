module GettextToI18n
  
  class Base
    attr_reader :translations
    
    def initialize
      @translations = {}
      transform_files!(Files.controller_files, :controller)
      transform_files!(Files.view_files, :view)
      transform_files!(Files.helper_files, :helper)

    end
    
    def transform_files!(files, type)  
      files.each do |file|
        convertor = Convertor.new(file, @translations, type)
        convertor.transform!
      end
    end
    
    
    def dump_yaml
      YAML::dump(@translations)
    end
    
    
    private 
    
    
    
  end
end