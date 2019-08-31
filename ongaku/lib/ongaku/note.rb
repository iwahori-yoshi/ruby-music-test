module Ongaku
  class Note
    attr_reader :frequency, :duration

    def initialize(frequency, duration)
      @frequency = frequency
      @duration = duration
    end

    def ==(other)
      @frequency == other.frequency &&
      @duration == other.duration
    end
  end

  class Rest
    attr_reader :frequency, :duration

    def initialize(duration)
      @duration = duration
    end

    def ==(other)
      @duration == other.duration
    end
  end
end