require 'uri'
require 'net/http'
require 'fileutils'
require 'phashion'

class DuplicateFinder
  def initialize(message, telegram_token, storage_folder: '/tmp/tiemur/')
    @message = message
    @file_id = message.photo.last.file_id

    @storage_folder = storage_folder

    @storage        = Storage.instance(message.chat.id)
    @telegram_token = telegram_token
    @telegram_api   = Telegram::Bot::Api.new(telegram_token)
  end

  def has_duplicate?
    return false unless download_image
    return false unless fingerprint

    if duplicate
      add_new_tiemur
      return true
    end

    add_new_record
    delete_file

    false
  end

  def duplicate
    @duplicate ||= storage[:fingerprints].find do |record|
      Phashion.hamming_distance(record[:fingerprint], fingerprint) <= Settings.get.default_dupe_threshold
    end
  end

  private

  attr_reader :storage, :message, :file_id, :telegram_token, :telegram_api, :storage, :storage_folder

  def build_record
    {
      message_id:   message.message_id,
      message_date: message.date,
      message_from: message_author_username,
      fingerprint:  fingerprint,
      file_id:      file_id
    }
  end

  def build_tiemur
    {
      original_message_id: duplicate[:message_id],
      message_id:          message.message_id,
      message_date:        message.date,
      message_from:        message_author_username,
      fingerprint:         fingerprint,
      file_id:             file_id,
    }
  end

  def message_author_username
    message.from.username || message.from.first_name
  rescue
    BotLogger.warn("Error while message_author_username: #{e.message}")

    "N/A"
  end

  def add_new_tiemur
    storage.add_record(build_tiemur, name: :tiemurs)
  end

  def add_new_record
    storage.add_record(build_record)
  end

  def fingerprint
    @fingerprint ||= Phashion::Image.new(@image_path).fingerprint
  rescue => e
    BotLogger.warn("Error while fingerprinting: #{e.message}")
    false
  end

  def download_image
    response = telegram_api.call('getFile', file_id: file_id)

    if response && response["ok"]
      file_path = response["result"]["file_path"]

      file_download_url = "https://api.telegram.org/file/bot#{telegram_token}/#{file_path}"
      ext = file_path.split('.').last

      downloaded_file_name = "#{storage_folder}#{Time.now.to_f}." + ext

      File.write(downloaded_file_name, Net::HTTP.get(URI.parse(file_download_url)))

      @image_path = downloaded_file_name

      return true
    end

    false
  rescue => e
    BotLogger.warn("welp, no photos, #{e.message}")

    false
  end

  def delete_file
    File.delete(@image_path)
  end
end
