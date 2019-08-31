require_relative 'unit'

module Ongaku
  module Turning
    module RestSymbol
      def 𝄻
        Rest.new(RelativeDuration.new(1, 1))
      end

      def 𝄼
        Rest.new(RelativeDuration.new(1, 2))
      end

      def 𝄽
        Rest.new(RelativeDuration.new(1, 4))
      end

      def 𝄾
        Rest.new(RelativeDuration.new(1, 8))
      end

      def 𝄿
        Rest.new(RelativeDuration.new(1, 16))
      end

      def 𝅀
        Rest.new(RelativeDuration.new(1, 32))
      end

      def 𝅁
        Rest.new(RelativeDuration.new(1, 64))
      end

      def 𝅂
        Rest.new(RelativeDuration.new(1, 128))
      end
    end

    module Standard
      include RestSymbol

      nature_map = [true, false, true, false, true, true, false, true, false, true, false, true]
      name_map = ['C', 'C', 'D', 'D', 'E', 'F', 'F', 'G', 'G', 'A', 'A', 'B']

      12.times do |half_step|
        if nature_map[half_step]
          names = ["#{name_map[half_step]}"]
        else
          names = ["#{name_map[half_step]}♯", "#{name_map[half_step+1]}♭"]
        end

        names.each do |name|
          const_set name, Class.new.extend(Module.new do
            define_method :[] do |octave|
              Frequency.from_Hz(440 * 2**((half_step - 9) / 12.0 + octave - 4))
            end
          end)
        end
      end
    end
  end
end