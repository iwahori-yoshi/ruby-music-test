RSpec.describe Ongaku::Player do
  it 'convert' do
    player1 = Ongaku::Player.new {|x| x+1}
    player2 = Ongaku::Player.new
    expect(player1.convert [1, 2, 3, 4]).to eql [2, 3, 4, 5]
    expect(player2.convert [1, 2, 3, 4]).to eql [1, 2, 3, 4]
  end
end
