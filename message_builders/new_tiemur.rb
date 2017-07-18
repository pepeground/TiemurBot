require 'relative_time'

class MessageBuilder
  class NewTiemur
    attr_reader :message_hash, :tiemur_message

    def initialize(message_hash, tiemur_message)
      @message_hash   = message_hash
      @tiemur_message = tiemur_message
    end

    def build
      if self_tiemured?
        "Ебать ты сам себя затемурил! It happened #{time_ago}, author: #{original_author}"
      else
        "Ебать ты Темур! It happened #{time_ago}, author: #{original_author}"
      end
    end

    private

    def self_tiemured?
      original_author == tiemur_author
    end

    def original_author
      message_hash[:message_from]
    end

    def tiemur_author
      tiemur_message.from.username
    end

    def time_ago
      time_ago = RelativeTime.in_words(
        Time.at(message_hash[:message_date]).utc,
        Time.now.utc
      )
    end
  end
end
