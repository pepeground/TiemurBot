class MessageBuilder
  class TopTiemurs
    attr_reader :top_tiemurs, :title

    def initialize(top_tiemurs, title = "Топ Темуров:")
      @top_tiemurs = top_tiemurs
      @title = title
    end

    def build
      top_tiemurs.inject(title) do |msg, (tiemur_name, count)|
        "#{msg} \n #{tiemur_name} => #{count}"
      end
    end
  end
end
