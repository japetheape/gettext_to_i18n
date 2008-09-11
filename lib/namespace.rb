module GettextToI18n
    class Namespace
        
        def initialize(namespace)
            @ids = []
            @namespace = namespace
        end
        
        def consume_id!(id = nil)
            id = "message_" + @ids.length.to_s if id.nil?
            raise "ID already in use" if @ids.include?(id)
            @ids << id
            return id
        end
        
        
    end
end