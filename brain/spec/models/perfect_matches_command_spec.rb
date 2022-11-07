require 'rails_helper'

describe PerfectMatchesCommand do
  describe '#execute' do
    it 'calls #all without a player name' do
      instance = described_class.new('league_id')

      expect(instance).to receive(:all) { "all" }

      expect(instance.execute).to eq("all")
    end

    it 'calls #solo with a player name' do
      instance = described_class.new('league_id', player_name: 'john')

      expect(instance).to receive(:solo) { "solo: john" }

      expect(instance.execute).to eq("solo: john")
    end
  end

  describe '#all' do
    let(:instance) { described_class.new('league_id') }
    let(:players) do
      ['gt', 'samii', 'tom', 'raj'].map { |name| Player.find_by(name: name) }
    end

    subject { instance.all }

    before do
      10.times do
        players.each do |p|
          FactoryBot.create(:entered_match, player: p, final_score: rand(89))
        end
      end

      2.times do
        FactoryBot.create(:entered_match, player: players[1], final_score: 90)
        FactoryBot.create(:entered_match, player: players[0], final_score: 90)
      end

      FactoryBot.create(:entered_match, player: players[2], final_score: 90)
    end

    specify do
      is_expected.to eq(<<~SLACK.strip)
        +------------------+
        | Perfect Matches  |
        +--------+---------+
        | Player | Matches |
        +--------+---------+
        | samii  | 2       |
        | gt     | 2       |
        | tom    | 1       |
        +--------+---------+
      SLACK
    end
  end

  describe '#solo' do
    let(:instance) { described_class.new('league_id', player_name: ['tom']) }

    let(:players) do
      ['gt', 'samii', 'tom', 'raj'].map { |name| Player.find_by(name: name) }
    end

    subject { instance.solo }

    before do
      match = FactoryBot.create(
        :kartalytics_match,
        player_one: players[0],
        player_two: players[1],
        player_three: players[2],
        player_four: players[3],
        player_one_score: 20,
        player_two_score: 30,
        player_three_score: 90,
        player_four_score: 40,
      )

      match.update_player_order!

      FactoryBot.create(:entered_match, kartalytics_match: match, player: players[2], final_score: 90)

      match = FactoryBot.create(
        :kartalytics_match,
        player_one: players[0],
        player_two: players[1],
        player_three: players[2],
        player_four: players[3],
        player_one_score: 88,
        player_two_score: 87,
        player_three_score: 90,
        player_four_score: 20,
      )

      match.update_player_order!

      FactoryBot.create(:entered_match, kartalytics_match: match, player: players[2], final_score: 90)
    end

    it { is_expected.to eq(<<~SLACK.strip) }
      +-----------------------------------------+
      |        2 Perfect Matches for tom        |
      +-----------------------------------------+
      | tom (90), gt (88), samii (87), raj (20) |
      | tom (90), raj (40), samii (30), gt (20) |
      +-----------------------------------------+
    SLACK
  end
end
