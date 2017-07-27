require 'pry'
require 'telegram/bot'

require_relative 'bot_logger'
require_relative 'settings'
require_relative 'storage'

require_relative 'duplicate_finder'
require_relative 'tiemurs_finder'

require_relative 'telegram_router'

require_relative 'message_builders/new_tiemur'
require_relative 'message_builders/top_tiemurs'
require_relative 'message_builders/database_size'

# Prepare
FileUtils.mkdir_p(Settings.get.storage_folder)

# Sometimes, telegram fails because fuck you, that's why!
begin
  Telegram::Bot::Client.new(Settings.get.telegram_token).run do |bot|
    bot.listen do |message|
      # next unless message.chat.id == -240220704 # debug

      if response = TelegramRouter.new(message).respond!
        bot.api.send_message(
                              chat_id: message.chat.id,
                              text:    response,
                              reply_to_message_id: message.message_id
                            )
      end
    end
  end
rescue => e
  BotLogger.warn("Telegram error! #{e.message}")
  sleep(5)
  retry
end
