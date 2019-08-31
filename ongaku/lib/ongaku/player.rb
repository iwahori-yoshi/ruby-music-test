require 'base64'
require 'wavefile'

module Ongaku
  class Player
    def initialize(
      input_channels: :mono,
      input_format_code: :float,
      output_channels: :mono,
      output_format_code: :pcm_16,
      &convertor)
      @input_format = WaveFile::Format.new(input_channels, input_format_code, SAMPLE_RATE)
      @output_format = WaveFile::Format.new(output_channels, output_format_code, SAMPLE_RATE)
      @convertor = convertor
    end

    def convert(input)
      @convertor ? input.map(&@convertor) : input
    end

    def play(input)
      io = StringIO.new
      buffer = WaveFile::Buffer.new(convert(input), @input_format)
      WaveFile::Writer.new(io, @output_format) do |writer|
        writer.write(buffer)
      end

      IRuby.display("<audio controls='true' style='width:100%' src='data:audio/wav;base64,#{ Base64.encode64(io.string) }'></audio>", mime:'text/html')
      return
    end
  end
end