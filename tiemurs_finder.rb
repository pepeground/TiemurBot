class TiemursFinder
  attr_reader :chat_id

  def initialize(chat_id)
    @chat_id = chat_id
  end

  def top(limit = 5)
    tiemurs.inject(Hash.new(0)) do |result_hash, tiemur|
      result_hash[tiemur[:message_from]] += 1

      result_hash
    end.sort_by { |_, v| v }.reverse.first(limit).to_h
  end

  def top_posters(limit = 5)
    fingerprints.inject(Hash.new(0)) do |result_hash, tiemur|
      result_hash[tiemur[:message_from]] += 1

      result_hash
    end.sort_by { |_, v| v }.reverse.first(limit).to_h
  end

  private

  def tiemurs
    storage[:tiemurs] || []
  end

  def fingerprints
    storage[:fingerprints] || []
  end

  def storage
    @storage ||= Storage.instance(@chat_id)
  end
end
