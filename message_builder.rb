require 'relative_time'

class MessageBuilder
  attr_reader :message_hash

  def initialize(message_hash)
    @message_hash = message_hash
  end

  def build
    "Ебать ты Темур!, It happened #{time_ago}, author: #{original_author}"
  end

  private

  def original_author
    message_hash[:message_from]
  end

  def time_ago
    time_ago = RelativeTime.in_words(
      Time.at(message_hash[:message_date]).utc,
      Time.now.utc
    )
  end
end
