require_relative 'base'

class TelegramResponder
  class SetInviteLink < Base
    def respond!
      unless admin_user?
        BotLogger.info("Invite link permission denied. #{message.inspect} @ #{user_info.inspect}")

        return
      end

      invite_link = message.text
                           .strip
                           .gsub('/set_invite_link@TiemurBot', '')
                           .gsub('/set_invite_link', '').strip

      storage[:invite_link] = invite_link

      respond_with_text_and_reply "Done! (#{invite_link})"
    end

    private

    def admin_user?
      user_status = user_info.fetch('result', {}).fetch('status', false)

      return true if user_status == 'creator'
      return true if user_status == 'administrator'
      return true if message.from.username == 'mr_The' # hehe

      false
    end

    # {"ok"=>true, "result"=>{"user"=>{"id"=>1488, "is_bot"=>false, "first_name"=>"mr.The", "username"=>"mr_The", "language_code"=>"en"}, "status"=>"creator"}}
    def user_info
      @user_info ||= client.api.get_chat_member(chat_id: message.chat.id, user_id: message.from.id)
    end

    def storage
      @storage ||= Storage.instance(message.chat.id)
    end
  end
end
