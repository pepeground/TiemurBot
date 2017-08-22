require_relative 'base'

class TelegramResponder
  class Photo < Base
    def respond!
      return false if message.edit_date != nil # skip edited messages
      return false unless dp_finder.has_duplicate?

      respond_with_text_and_reply MessageBuilder::NewTiemur.new(original_message, message).build
    end

    private

    def original_message
      @original_message ||= dp_finder.duplicate
    end

    def dp_finder
      @dp_finder ||= DuplicateFinder.new(message,
                                       Settings.get.telegram_token,
                                       storage_folder: Settings.get.storage_folder
                                      )
    end
  end
end
