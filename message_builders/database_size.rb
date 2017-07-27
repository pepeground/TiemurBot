class MessageBuilder
  class DatabaseSize
    attr_reader :database_size

    def initialize(database_size)
      @database_size = database_size
    end

    def build
      "\nDatabase size: #{database_size}"
    end
  end
end
