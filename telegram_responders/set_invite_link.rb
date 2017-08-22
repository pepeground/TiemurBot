require_relative 'base'

class TelegramResponder
  class SetInviteLink < Base
    def respond!
      invite_link = message.text
                           .strip
                           .gsub('/set_invite_link@TiemurBot', '')
                           .gsub('/set_invite_link', '').strip

      storage[:invite_link] = invite_link

      respond_with_text_and_reply "Done! (#{invite_link})"
    end

    private

    def storage
      @storage ||= Storage.instance(message.chat.id)
    end
  end
end
