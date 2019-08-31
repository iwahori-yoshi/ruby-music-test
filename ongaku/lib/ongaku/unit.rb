require_relative 'note'

module Ongaku
  class Unit
    def initialize(value)
      @value = value
    end

    def to_f
      @value.to_f
    end

    def ==(other)
      to_f == other.to_f
    end
  end

  class Frequency < Unit
    def self.from_Hz(value)
      self.new(value)
    end

    def self.from_kHz(value)
      self.new(value*1000)
    end

    def inspect
      "#{to_f} Hz"
    end

    def create_note(*argv)
      if argv.length == 1
        if argv[0].is_a?(AbsoluteDuration)
          return Note.new(self, argv[0])
        end
      else
        return Note.new(self, RelativeDuration.new(*argv))
      end

      raise ArgumentError(argv)
    end

    def 𝅝
      create_note(1, 1)
    end

    def 𝅗𝅥
      create_note(1, 2)
    end

    def 𝅘𝅥
      create_note(1, 4)
    end

    def 𝅘𝅥𝅮
      create_note(1, 8)
    end

    def 𝅘𝅥𝅯
      create_note(1, 16)
    end

    def 𝅘𝅥𝅰
      create_note(1, 32)
    end

    def 𝅘𝅥𝅱
      create_note(1, 64)
    end

    def 𝅘𝅥𝅲
      create_note(1, 128)
    end
  end

  class AbsoluteDuration < Unit
    def self.from_s(value)
      self.new(value)
    end

    def self.from_ms(value)
      self.new(value/1000.0)
    end

    def to_abs(speed)
      self
    end

    def inspect
      "#{to_f} s"
    end
  end

  class RelativeDuration < Unit
    def initialize(numerator, denominator)
      super(Rational(numerator, denominator))
    end

    def to_abs(speed)
      whole_note_duration = 60.0 / speed * 4
      AbsoluteDuration.from_s(whole_note_duration * @value)
    end
  end

  module UnitExt
    refine Numeric do
      def Hz
        Frequency.from_Hz(self)
      end

      def kHz
        Frequency.from_kHz(self)
      end

      def s
        AbsoluteDuration.from_s(self)
      end

      def ms
        AbsoluteDuration.from_ms(self)
      end
    end
  end
end