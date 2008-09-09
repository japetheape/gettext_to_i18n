# GettextToI18n
module GettextToI18n
  
  class Files
   
    # all files that contain some gettext methods
    def self.all_files
      self.controller_files + self.view_files + self.helper_files
    end
    
    # All controller files
    def self.controller_files
      self.get_files('controllers', '*.rb')
    end
    
    # All view files
    def self.view_files
      self.get_files('views', '**/*.erb')
    end
    
    # All view files
    def self.helper_files
      self.get_files('helpers', '*.rb')
    end
    
    
    private 
    
    def self.chdir
      
      
      Dir.chdir(RAILS_ROOT)
    end

    # All files we need to walk
    def self.get_files(filter = '**', types='*.{erb,rb}')
      self.chdir
      Dir.glob("app/#{filter}/#{types}")
    end
  end
end