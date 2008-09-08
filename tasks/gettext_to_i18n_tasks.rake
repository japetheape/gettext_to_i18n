# desc "Explaining what the task does"
# task :gettext_to_i18n do
#   # Task goes here
# end

require File.dirname(__FILE__) + '/../init'

namespace :gettext_to_i18n do
  desc 'Men'
  task :display_files do
    GettextToI18n::Files.all_files
  end
end
