class TelegramResponder
  class Stats
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def respond!
      [
        MessageBuilder::TopTiemurs.new(top_tiemurs).build,
        MessageBuilder::DatabaseSize.new(database_size).build
      ].join("\n")
    end

    private

    def database_size
      storage[:fingerprints].size || 0
    end

    def storage
      @storage ||= Storage.instance(message.chat.id)
    end

    def top_tiemurs
      @top_tiemurs ||= TiemursFinder.new(message.chat.id).top
    end
  end
end
