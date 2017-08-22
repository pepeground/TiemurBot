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
        "Ебать ты сам себя затемурил! It happened #{time_ago}, author: #{original_author} #{proof_link}"
      else
        "Ебать ты Темур! It happened #{time_ago}, author: #{original_author} #{proof_link}"
      end
    end

    private

    def storage
      @storage ||= Storage.instance(tiemur_message.chat.id)
    end

    def proof_link
      if storage[:invite_link]
        invite_link = storage[:invite_link]
        message_id  = message_hash[:message_id]

        return ", Proof: #{invite_link}/#{message_id}"
      end

      ""
    end

    def self_tiemured?
      original_author == tiemur_author
    end

    def original_author
      message_hash[:message_from]
    end

    def tiemur_author
      tiemur_message.from.username || tiemur_message.from.first_name
    rescue
      BotLogger.warn("Error while message_author_username: #{e.message}")

      "N/A"
    end

    def time_ago
      time_ago = RelativeTime.in_words(
        Time.at(message_hash[:message_date]).utc,
        Time.now.utc
      )
    end
  end
end
