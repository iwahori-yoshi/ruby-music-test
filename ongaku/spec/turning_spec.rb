RSpec.describe Ongaku::Turning::Standard do
  using Ongaku::UnitExt
  include Ongaku::Turning::Standard

  it 'works' do
    expect(Ongaku::Turning::Standard::A[4]).to be == 440.Hz
    expect(𝄻).to be == Ongaku::Rest.new(Ongaku::RelativeDuration.new(1, 1))
  end
end

