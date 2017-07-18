require 'pry'
require 'telegram/bot'

require_relative 'bot_logger'
require_relative 'settings'
require_relative 'storage'
require_relative 'duplicate_finder'

require_relative 'tiemurs_finder'

require_relative 'message_builders/new_tiemur'
require_relative 'message_builders/top_tiemurs'

# Prepare
FileUtils.mkdir_p(Settings.get.storage_folder)

# Sometimes, telegram fails because fuck you, that's why!
begin
  Telegram::Bot::Client.new(Settings.get.telegram_token).run do |bot|
    bot.listen do |message|
      # return unless message.chat.id == -240220704 # debug

      if message.photo.any?
        dp_finder = DuplicateFinder.new(message, Settings.get.telegram_token, storage_folder: Settings.get.storage_folder)

        if dp_finder.has_duplicate?
          original_message = dp_finder.duplicate

          response_message = MessageBuilder::NewTiemur.new(original_message, message).build

          bot.api.send_message(chat_id: message.chat.id, text: response_message, reply_to_message_id: message.message_id)

          BotLogger.info("New Tiemur! #{message.from.username}, #{response_message}")
        end
      else
        case message.text
        when '/tiemur_stats'
          top_tiemurs = TiemursFinder.new(message.chat.id).top
          response_message = MessageBuilder::TopTiemurs.new(top_tiemurs).build

          bot.api.send_message(chat_id: message.chat.id, text: response_message, reply_to_message_id: message.message_id)

          BotLogger.info("Tiemur stats requested. #{message.from.username}, #{response_message}")
        end
      end
    end
  end
rescue => e
  BotLogger.warn("Telegram error! #{e.message}")
  sleep(5)
  retry
end
