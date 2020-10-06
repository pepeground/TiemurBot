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

$0 = 'ruby_tiemur_bot'

# Sometimes, telegram fails because fuck you, that's why!
begin
  Telegram::Bot::Client.new(Settings.get.telegram_token).run do |bot|
    bot.listen do |message|
      if response = TelegramRouter.new(message, bot).respond!
        bot.api.public_send(
          response[:method],
          response[:params].merge(chat_id: message.chat.id)
        )
      end
    end
  end
rescue => e
  BotLogger.warn("Telegram error! #{e.message}, #{e.backtrace}")
  sleep(5)
  retry
end
