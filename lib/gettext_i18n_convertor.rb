module GettextToI18n
  class GettextI18nConvertor
    attr_accessor :text
    
    def initialize(text, namespace = nil)
      @text = text
      @namespace = namespace
    end
    
    # The contents of the method call
    def contents
      /\_\([\"\']([^\'\"]*)[\"\'].*\)/.match(@text)[1]
    end
    
    # Returns the part after the method call, 
    # _('aaa' % :a => 'sdf', :b => 'agh') 
    # return :a => 'sdf', :b => 'agh'
    def variable_part
      @variable_part_cached ||= begin
          result = /\% \{(.*)\}/.match(@text)
          if result
              result[1]
          end
      end
    end
    
    # Extract the variables out of a gettext variable part
    # We cannot simply split the variable part on a comma, because it
    # can contain gettext calls itself.
    # Example: :a => 'a', :b => 'b' => [":a => 'a'", ":b => 'b'"]
    def get_variables_splitted
      return if variable_part.nil? 
      in_double_quote = in_single_quote = false
      method_indent = 0  
      s = 0
      vars = []
      variable_part.length.times do |i|
        token = variable_part[i..i]
        in_double_quote = !in_double_quote if token == "\""
        in_single_quote = !in_single_quote if token == "'"
        method_indent += 1 if token == "("
        method_indent -= 1 if token == ")"
        if (token == "," && method_indent == 0 && !in_double_quote && !in_single_quote) || i == variable_part.length - 1
          e = (i == variable_part.length - 1) ? (i ) : i - 1
          vars << variable_part[s..e]
          s = i + 1
        end
      end
      return vars
    end
    
    # Return a array of hashes containing the variables used in the
    # gettext call.
    def variables
      @variables_cached ||= begin
        vsplitted = get_variables_splitted
        return nil if vsplitted.nil?
        vsplitted.map! { |v| 
          r = v.match(/ *:(\w+) *=> *(.*)/)
          {:name => r[1], :value => GettextI18nConvertor.string_to_i18n(r[2], @namespace)}
        }
      end
    end
    
    # After analyzing the variable part, the variables
    # it is now time to construct the actual i18n call
    def to_i18n
      id = @namespace.consume_id!
      output = "t(:#{id}"
      if !self.variables.nil?
          vars = self.variables.collect { |h| {:name => h[:name], :value => h[:value] }}
          output += ", " + vars.collect {|h| ":#{h[:name]} => #{h[:value]}"}.join(", ")
      end
      output += ")"
      return output
    end
    
    # Takes the gettext calls out of a string and converts
    # them to i18n calls
    def self.string_to_i18n(text, namespace)
      s = self.indexes_of(text, /_\(/)
      e = self.indexes_of(text, /\)/)
      
      indent, startindex, endinde, methods  = 0, -1, -1, []
      output = ""
      text.length.times do |i|
        if s.include?(i)
          startindex = i if indent == 0
          indent += 1
        end
        
        output += text[i..i].to_s if indent <= 0
       
        if e.include?(i)
          indent -= 1
          if indent == 0
            endindex = i
            output += GettextI18nConvertor.new(text[startindex..endindex], namespace).to_i18n 
          end
        end
      end
      output
    end
    
    
    
    #######TEMP#########
    # Converts the gettext contents to i18n contents
    # It rewrites the variables
    def self.convert_contents(contents)
      contents.gsub!(GettextHelper::GETTEXT_VARIABLES, '{{\1}}')
      contents.gsub!(/^(\"|\')/, '')
      contents.gsub!(/(\"|\')$/, '')
      contents
    end

     
    
    
    private 
    
    # Finds indexes of some pattern(regexp) in a string
    def self.indexes_of(str, pattern)
      indexes = []
      str.length.times do |i|
        match = str.index(pattern, i)
        indexes << match if !indexes.include?(match)
      end
      indexes
    end
    
  end
end