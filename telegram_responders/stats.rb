require_relative 'base'

class TelegramResponder
  class Stats < Base
    def respond!
      respond_with_text_and_reply [
        MessageBuilder::TopTiemurs.new(top_tiemurs).build,
        MessageBuilder::TopTiemurs.new(top_posters, "Топ постеров:").build,
        MessageBuilder::TopTiemurs.new(top_posters, "Коэффициент темуринга, %:").build,
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
      @top_tiemurs ||= tiemurs_finder.top
    end

    def top_posters
      @top_posters ||= tiemurs_finder.top_posters
    end

    def tiemurs_finder
      @tiemurs_finder ||= TiemursFinder.new(message.chat.id)
    end
  end
end
