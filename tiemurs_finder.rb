class TiemursFinder
  attr_reader :chat_id

  def initialize(chat_id)
    @chat_id = chat_id
  end

  def top(limit = 5)
    all_tiemurs.sort_by { |_, v| v }.reverse.first(limit).to_h
  end

  def top_posters(limit = 5)
    all_posters.sort_by { |_, v| v }.reverse.first(limit).to_h
  end

  def relative_top(limit = 5)
    all_tiemurs.map do |name, duplicates_count|
      uniq_images_count = all_posters[name]

      return [name, 1488] if uniq_images_count.to_i <= 0 && duplicates_count > 0

      next if uniq_images_count.to_i <= 0

      percent = (duplicates_count.to_f / uniq_images_count.to_f * 100).round(2)

      [name, percent]
    end.compact.to_h.sort_by { |_, v| v }.reverse.first(limit).to_h
  end

  private

  def all_posters
    @all_posters ||= fingerprints.inject(Hash.new(0)) do |result_hash, tiemur|
      result_hash[tiemur[:message_from]] += 1

      result_hash
    end
  end

  def all_tiemurs
    @all_tiemurs ||= tiemurs.inject(Hash.new(0)) do |result_hash, tiemur|
      result_hash[tiemur[:message_from]] += 1

      result_hash
    end
  end

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
