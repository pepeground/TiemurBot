require_relative 'base'

class TelegramResponder
  class Proof < Base
    def respond!
      return false unless reply?
      return false if tiemur_message.nil?
      return false if tiemur_message[:original_message_id].nil?

      {
        method: :forward_message,
        params: {
          from_chat_id: message.chat.id,
          message_id:   tiemur_message[:original_message_id]
        }
      }
    end

    private

    def reply
      message.reply_to_message
    end

    def reply?
      reply != nil
    end

    def tiemur_message
      @tiemur_message ||= storage[:tiemurs].find do |record|
        record[:message_id] == reply.message_id
      end
    end


    def storage
      @storage ||= Storage.instance(message.chat.id)
    end
  end
end
