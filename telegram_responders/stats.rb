class TelegramResponder
  class Stats
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def respond!
      MessageBuilder::TopTiemurs.new(top_tiemurs).build
    end

    private

    def top_tiemurs
      @top_tiemurs ||= TiemursFinder.new(message.chat.id).top
    end
  end
end
