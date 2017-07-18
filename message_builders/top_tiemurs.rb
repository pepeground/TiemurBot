class MessageBuilder
  class TopTiemurs
    attr_reader :top_tiemurs

    def initialize(top_tiemurs)
      @top_tiemurs = top_tiemurs
    end

    def build
      top_tiemurs.inject("Топ Темуров:") do |msg, (tiemur_name, count)|
        "#{msg} \n #{tiemur_name} => #{count}"
      end
    end
  end
end
