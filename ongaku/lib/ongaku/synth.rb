require_relative 'const'
require_relative 'note'

module Ongaku
  class Synth
    attr_accessor :speed
    attr_writer :amp

    def initialize(speed, amp)
      @speed = speed
      @amp = amp
      @freq = nil
      @progress = 0
      @duration = 0
    end

    def convert(input)
      output = []
      state = {}

      input.each do |item|
        case item
        when Note
          output += convert_note(item)
        when Rest
          output += convert_rest(item)
        when Array
          output += convert(item)
        when SynthConfigPush
          key = :"@#{item.key}"
          raise StandardError.new('SynthConfigPush error') unless instance_variables.index(key)
          old_value = instance_variable_get(key)
          state[key] = [] unless state[key]
          state[key].push(old_value)
          instance_variable_set(key, item.value)
        when SynthConfigPop
          key = :"@#{item.key}"
          value = state[key].pop
          instance_variable_set(key, value)
        else
          raise TypeError.new("item.class is #{item.class}")
        end
      end

      state.each do |key, values|
        instance_variable_set(key, values[0]) if values.length > 0
      end

      return output
    end

    def amp
      @amp.is_a?(Proc) ? @amp.call(@duration, @progress) : @amp
    end

  private
    def convert_note(note)
      @duration = note.duration.to_abs(@speed)
      duration = @duration.to_f
      frequency = note.frequency.to_f
      num_samples = (duration * SAMPLE_RATE).to_i
      phase_delta = frequency / SAMPLE_RATE

      total = num_samples - 1
      last_phase = phase = -1
      last_frequency = frequency
      (0..total).map do |i|
        @progress = i.to_f / total
        if @freq
          new_frequency = @freq.call(frequency, duration, @progress).to_f
          if new_frequency != last_frequency
            last_frequency = new_frequency
            phase_delta = new_frequency / SAMPLE_RATE
          end
        end
        last_phase = phase
        phase = (phase + phase_delta) % 1.0
        sample(phase, last_phase > phase)
      end
    end

    def convert_rest(rest)
      duration = rest.duration.to_abs(@speed).to_f
      num_samples = (duration * SAMPLE_RATE).to_i

      Array.new(num_samples, 0)
    end
  end

  class SynthConfigPush
    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end
  end
  
  class SynthConfigPop
    attr_reader :key

    def initialize(key)
      @key = key
    end
  end
end