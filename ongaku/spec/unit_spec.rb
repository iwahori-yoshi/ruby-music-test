RSpec.describe Ongaku::UnitExt do
  using Ongaku::UnitExt

  it 'create from numeric' do
    expect(1.Hz.class).to eql Ongaku::Frequency
    expect(1.kHz.class).to eql Ongaku::Frequency
    expect(1.s.class).to eql Ongaku::AbsoluteDuration
    expect(1.ms.class).to eql Ongaku::AbsoluteDuration
    expect(1.Hz.to_f).to eql 1.0
    expect(1.kHz.to_f).to eql 1000.0
    expect(1.s.to_f).to eql 1.0
    expect(1.ms.to_f).to eql 0.001
  end
end

RSpec.describe Ongaku::Frequency do
  using Ongaku::UnitExt

  it 'create note' do
    expect(1.Hz.create_note(1.s)).to be == Ongaku::Note.new(1.Hz, 1.s)
    expect(1.Hz.𝅝).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 1))
    expect(1.Hz.𝅗𝅥).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 2))
    expect(1.Hz.𝅘𝅥).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 4))
    expect(1.Hz.𝅘𝅥𝅮).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 8))
    expect(1.Hz.𝅘𝅥𝅯).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 16))
    expect(1.Hz.𝅘𝅥𝅰).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 32))
    expect(1.Hz.𝅘𝅥𝅱).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 64))
    expect(1.Hz.𝅘𝅥𝅲).to be == Ongaku::Note.new(1.Hz, Ongaku::RelativeDuration.new(1, 128))
  end
end