require 'yaml'
require 'ostruct'

class Settings
  SETTINGS_FILE = 'settings.yml'

  def self.get
    @settings ||= OpenStruct.new(
      YAML.load_file(SETTINGS_FILE)
    )
  end
end
