# GettextToI18n
module GettextToI18n
  class Files
    def self.chdir
      Dir.chdir(File.join(File.dirname(__FILE__), '..', '..', '..','..'))
    end
    
    # All files we need to walk
    def self.all_files(filter = '**', types='*.{erb,rb}')
      self.chdir
      Dir.glob("app/#{filter}/#{types}")
    end
    
    # ALl controller files we need to walk
    def self.controller_files
      self.all_files('controllers', '*.rb')
    end
    
    # All view files we need to walk
    def self.view_files
      self.all_files('views', '**/*.erb')
    end
  end
  
  
  
end