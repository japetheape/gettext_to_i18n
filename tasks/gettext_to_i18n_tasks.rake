# desc "Explaining what the task does"
# task :gettext_to_i18n do
#   # Task goes here
# end

require File.dirname(__FILE__) + '/../init'

namespace :gettext_to_i18n do
  
  desc 'Transforms all of your files into the new I18n api format'
  task :transform do
    a = GettextToI18n::Base.new
    a.dump_yaml!
  end
  
  
end
