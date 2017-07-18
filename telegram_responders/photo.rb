class TelegramResponder
  class Photo
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def respond!
      return false unless dp_finder.has_duplicate?

      MessageBuilder::NewTiemur.new(original_message, message).build
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
