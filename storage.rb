require 'pstore'

class Storage
  attr_reader :store

  def self.instance(chat_id, db_name: 'tiemur_database')
    @instances ||= {}

    unless @instances.has_key?(chat_id)
      @instances[chat_id] = new("#{db_name}_#{chat_id}")
    end

    @instances[chat_id]
  end

  def initialize(db_name = 'tiemur_database')
    @store = PStore.new("#{db_name}.pstore")
    self[:fingerprints] ||= []
  end

  def add_record(record, name: :fingerprints)
    self[name] = self[name].push(record)
  end

  def []=(key, value)
    store.transaction { store[key] = value }
  end

  def [](key)
    store.transaction { store[key] }
  end
end
