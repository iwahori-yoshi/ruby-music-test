RSpec.describe Ongaku::Synth do
  let(:test_synth_class) do
    Class.new(Ongaku::Synth) do
      attr_accessor :duty
    
      def initialize(speed, amp, duty)
        super(speed, amp)
        @duty = duty
      end
    
      def sample(phase, tick)
        phase < duty ? amp : 0
      end
    end
  end

  using Ongaku::UnitExt

  it 'converts data' do
    synth = test_synth_class.new(150, 15, 0.125)
    note = Ongaku::Note.new(480.Hz, 1.ms)
    output = synth.convert [note]
    expect(output.length).to eql 48

    expect_output = Array.new(output.length)
    phase = 0
    phase_delta = 480.0 / Ongaku::SAMPLE_RATE
    output.length.times do |i|
      expect_output[i] = (phase < 0.125 ? 15 : 0)
      phase = (phase + phase_delta) % 1.0
    end
    expect(output).to eql expect_output
  end

  it 'can pass config' do
    synth = test_synth_class.new(150, 15, 0.125)
    output = synth.convert [Ongaku::SynthConfigPush.new(:amp, 1), Ongaku::Note.new(480.Hz, 1.ms)]
    expect(output[0]).to eql 1
  end
end
