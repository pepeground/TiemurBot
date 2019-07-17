class TelegramResponder
  class Base
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def respond!
      raise NotImplementedError
    end

    private

    def respond_with_text_and_reply(response_message)
      {
        method: :send_message,
        params: {
          text:                     response_message,
          reply_to_message_id:      message.message_id,
          disable_web_page_preview: true
        }
      }
    end
  end
end
