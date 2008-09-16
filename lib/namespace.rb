module GettextToI18n
  class Namespace
    attr_reader :ids
    
    def initialize(name)
      @ids = {}
      @namespace = name
    end
    
    # reserves a id
    def consume_id!(id = nil)
      id = "message_" + @ids.length.to_s if id.nil?
      raise "ID already in use" if @ids.keys.include?(id)
      @ids[id] = ""
      return id
    end
    
    
    
    def set_id(id, value)
      @ids[id] = value
    end
    
    
    def to_s
      o = "Namespace: {" + @namespace
      o <<  @ids.to_yaml
      o << "}"
    end
    
    def i18n_namespace
      @cached_i18n_namespace ||= begin
        a = @namespace.dup
        #a.delete("txt")
        a.delete(Base::DEFAULT_LANGUAGE)
        a
      end
    end
    
    
    def to_i18n_scope
      @cached_i18n_scope ||= ":scope => [%s]" % i18n_namespace.collect {|x| ":#{x}"}.join(", ")
    end
    
    
    def merge(base)
      loc = ""
      @namespace.each do |v|
        loc << "[\"#{v}\"]"
        arr = 'base' + loc 
        eval  arr + ' = {} if ' + arr + '.nil?' 
      end
     
      eval 'base' + loc + ' = @ids'
      
    end
    
  end
end