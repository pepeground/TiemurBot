require 'logger'

class BotLogger
  LOG_FILE = 'tiemur.log'

  def self.warn(msg)
    log.warn(msg)
  end

  def self.info(msg)
    log.info(msg)
  end

  def self.log
    @logger ||= Logger.new(LOG_FILE)
  end
end
