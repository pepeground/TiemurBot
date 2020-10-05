require_relative 'telegram_responders/photo'
require_relative 'telegram_responders/stats'
require_relative 'telegram_responders/proof'
require_relative 'telegram_responders/set_invite_link'

class TelegramRouter
  attr_reader :message, :client

  def initialize(message, client)
    @message = message
    @client = client
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
    when /\A\/set_invite_link/
      if response = TelegramResponder::SetInviteLink.new(message, client: client).respond!
        BotLogger.info("Invite link set. #{message.from.username}, #{response}")

        return response
      end
    when '/proof', '/proof@TiemurBot'
      if response = TelegramResponder::Proof.new(message).respond!
        BotLogger.info("Tiemur proofs requested. #{message.from.username}, #{response}")

        return response
      end
    when '/tiemur_stats', '/tiemur_stats@TiemurBot'
      if response = TelegramResponder::Stats.new(message).respond!
        BotLogger.info("Tiemur stats requested. #{message.from.username}, #{response}")

        return response
      end
    end

    false
  end
end
