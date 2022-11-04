require 'rails_helper'

describe GenCoursesCommand do
  describe '#execute' do
    let(:instance) { described_class.new('league_id') }
    let!(:p1) { FactoryBot.create(:player, name: "p1") }
    let!(:course) { FactoryBot.create(:kartalytics_course, name: 'Dolphin Shoals') }
    let!(:race) { FactoryBot.create(:entered_race, course: course, player: p1, race_time: 51) }
    subject { instance.execute }

    before do
      srand(10)
    end


    specify do
      expectation = <<~EOF
        *Tracks to play*:

        1. :star_cup: Dolphin Shoals
        Fastest time: 51.0s by p1
        2. :lightning_cup: Piranha Plant Pipeway
        3. :egg_cup: Yoshi Circuit (GameCube)
        4. :mushroom_cup: Mario Kart Stadium
        5. :lucky_cat_cup: Shroom Ridge
        6. :banana_cup: DK Jungle (3DS)
      EOF

      res = subject
      expect(res[:type]).to eq(:raw)
      expect(res[:text]).to eq(expectation)
    end
  end
end
