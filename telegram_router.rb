require_relative 'telegram_responders/photo'
require_relative 'telegram_responders/stats'

class TelegramRouter
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def respond!
    (message.photo.any? && photo_response) || text_response
  end

  def photo_response
    if response = TelegramResponder::Photo.new(message).respond!
      BotLogger.info("New Tiemur! #{message.from.username}, #{response}")

      return response
    end

    false
  end

  def text_response
    case message.text
    when '/tiemur_stats'
      if response = TelegramResponder::Stats.new(message).respond!
        BotLogger.info("Tiemur stats requested. #{message.from.username}, #{response}")

        return response
      end
    end

    false
  end
end
