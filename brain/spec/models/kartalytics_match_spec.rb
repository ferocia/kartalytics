# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KartalyticsMatch, type: :model do
  let(:player_one) { FactoryBot.create(:player, name: 'player_one') }
  let(:player_two) { FactoryBot.create(:player, name: 'player_two') }
  let(:player_three) { FactoryBot.create(:player, name: 'player_three') }
  let(:match) { FactoryBot.create(:match, players_in_order: 'player_three,player_two,player_one') }
  let(:status) { 'in_progress' }
  let(:player_count) { 3 }

  let(:kartalytics_match) { FactoryBot.create(:kartalytics_match,
    created_at: 6.minutes.ago,
    match: match,
    status: status,
    player_count: player_count,
    player_one: player_one,
    player_one_score: 75,
    player_one_order: 2,
    player_one_position: 3,
    player_two: player_two,
    player_two_score: 75,
    player_two_order: 1,
    player_two_position: 2,
    player_three: player_three,
    player_three_score: 90,
    player_three_order: 0,
    player_three_position: 1,
    player_four_order: 3,
    player_four_position: nil,
  ) }

  describe '.current_match' do
    it 'returns nil when no matches' do
      KartalyticsMatch.all.each(&:destroy)
      expect(KartalyticsMatch.current_match).to eq(nil)
    end
  end

  describe '.recent_unassigned_for' do
    let(:three_player_kartalytics_match) { FactoryBot.create(:kartalytics_match, created_at: 6.minutes.ago, player_count: 3, status: 'finished') }
    let(:four_player_kartalytics_match) { FactoryBot.create(:kartalytics_match, created_at: 5.hours.ago, player_count: 4, status: 'in_progress') }

    subject { described_class.recent_unassigned_for(player_count) }

    before do
      # assigned matches within the time scope (should be ignored)
      FactoryBot.create(:kartalytics_match, created_at: 5.hours.ago, match: match, player_count: 3)
      FactoryBot.create(:kartalytics_match, created_at: 6.minutes.ago, match: match, player_count: 4)

      # abandoned matches within the time scope (should be ignored)
      FactoryBot.create(:kartalytics_match, created_at: 5.hours.ago, player_count: 3, status: 'abandoned')
      FactoryBot.create(:kartalytics_match, created_at: 6.minutes.ago, player_count: 4, status: 'abandoned')

      # unassigned matches outside the time scope (should be ignored)
      FactoryBot.create(:kartalytics_match, created_at: 7.hours.ago, player_count: 3)
      FactoryBot.create(:kartalytics_match, created_at: 10.days.ago, player_count: 4)
    end

    context 'for 3 players' do
      let(:player_count) { 3 }

      it 'returns 3 player matches' do
        expect(subject).to eq([three_player_kartalytics_match])
      end
    end

    context 'for 4 players' do
      let(:player_count) { 4 }

      it 'returns 4 player matches' do
        expect(subject).to eq([four_player_kartalytics_match])
      end
    end
  end

  describe 'associate_match!' do
    subject(:associate_match!) { kartalytics_match.associate_match!(match) }

    before do
      KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first)
    end

    context 'when the match is in progress' do
      it 'does not create entered matches or race' do
        associate_match!

        expect(kartalytics_match.entered_matches.count).to eq(0)
        expect(kartalytics_match.entered_races.count).to eq(0)
      end
    end

    context 'when the match is finished' do
      let(:status) { 'finished' }

      it 'creates entered matches and races' do
        associate_match!

        expect(kartalytics_match.entered_matches.count).to eq(3)
        expect(kartalytics_match.entered_races.count).to eq(3)
      end

      context 'when the player count is mismatched' do
        let(:match) { FactoryBot.create(:match, players_in_order: 'player_three') }

        it 'unassigns the match' do
          associate_match!

          expect(kartalytics_match.match).to be_nil
        end
      end
    end
  end

  describe 'unassociate_match!' do
    subject { kartalytics_match }

    before do
      subject.unassociate_match!
    end

    it 'resets match and players' do
      expect(subject.match).to be_nil
      expect(subject.player_one).to be_nil
      expect(subject.player_two).to be_nil
      expect(subject.player_three).to be_nil
    end
  end

  describe 'update_player_order!' do
    subject { kartalytics_match }

    before do
      match.update(players_in_order: 'player_three,player_one,player_two')
      subject.update_player_order!
    end

    it 'assigns players in ikk order' do
      expect(subject.player_one_order).to eq(2)
      expect(subject.player_two_order).to eq(1)
      expect(subject.player_three_order).to eq(0)
      expect(subject.player_four_order).to eq(3)
    end
  end

  describe '#update_player_scores_from_event!' do
    subject { kartalytics_match }

    let(:event) do
      {
        data: {
          player_one: { score: 87 },
          player_two: { score: 76 },
          player_three: { score: 60 },
          player_four: { score: 54 },
        }
      }.with_indifferent_access
    end

    let!(:race) do
      FactoryBot.create(:kartalytics_race,
        match: subject,
        status: 'in_progress',
        player_one_score: 10,
        player_two_score: 15,
        player_three_score: 12,
        player_four_score: 9,
      )
    end

    context 'when all races have been finalised' do
      before do
        race.update(status: 'finished')
        subject.update_player_scores_from_event!(event)
      end

      it 'calculates player scores from finished race results' do
        expect(subject.player_one_score).to eq(10)
        expect(subject.player_two_score).to eq(15)
        expect(subject.player_three_score).to eq(12)
        expect(subject.player_four_score).to eq(9)
        expect(subject.players_in_order).to eq([:player_two, :player_three, :player_one, :player_four])
      end
    end

    context 'when some races have not been finalised' do
      before do
        race.update(status: 'in_progress')
        subject.update_player_scores_from_event!(event)
      end

      it 'updates player scores from the event data' do
        expect(subject.player_one_score).to eq(87)
        expect(subject.player_two_score).to eq(76)
        expect(subject.player_three_score).to eq(90) # 90 because [current_score, event_score].max
        expect(subject.player_four_score).to eq(54)
        expect(subject.players_in_order).to eq([:player_three, :player_one, :player_two, :player_four])
      end
    end
  end

  describe 'reassign_player_names!' do
    subject { kartalytics_match }

    before do
      subject.reassign_player_names!
    end

    context 'when the associated players are in the correct order' do
      it 'does not change the player order' do
        expect(subject.player_one.name).to eq('player_one')
        expect(subject.player_two.name).to eq('player_two')
        expect(subject.player_three.name).to eq('player_three')
      end
    end

    context 'when the associated players are not in the correct order' do
      let(:match) { FactoryBot.create(:match, players_in_order: 'player_three,player_one,player_two') }

      it 'reassigns the players' do
        expect(subject.player_one.name).to eq('player_two')
        expect(subject.player_two.name).to eq('player_one')
        expect(subject.player_three.name).to eq('player_three')
      end
    end
  end

  describe 'players_in_order' do
    subject { kartalytics_match.players_in_order }

    it 'orders players by order attribute' do
      is_expected.to eq([:player_three, :player_two, :player_one, :player_four])
    end
  end

  describe 'players_in_ikk_order' do
    subject { kartalytics_match.players_in_ikk_order }

    context 'when player_two is lower than player_one on the leaderboard' do
      before do
        match.update(players_in_order: 'player_one,player_two,player_three')
      end

      it { is_expected.to eq([:player_three, :player_two, :player_one, :player_four]) }
    end

    context 'when player_one is lower than player_two on the leaderboard' do
      before do
        match.update(players_in_order: 'player_two,player_one,player_three')
      end

      it { is_expected.to eq([:player_three, :player_one, :player_two, :player_four]) }
    end

    context 'when player_two is not on the leaderboard' do
      before do
        match.update(players_in_order: 'player_one,player_three')
      end

      it { is_expected.to eq([:player_three, :player_two, :player_one, :player_four]) }
    end
  end

  describe '#associate_players!' do
    context 'when the match is unassigned' do
      it 'assigns players' do
        kartalytics_match.unassociate_match!
        kartalytics_match.associate_players!(player_two: player_two)

        expect(kartalytics_match.player_one).to be_nil
        expect(kartalytics_match.player_two).to eq(player_two)
        expect(kartalytics_match.player_three).to be_nil
      end
    end

    context 'when the match is assigned' do
      it 'raises an error' do
        expect { kartalytics_match.associate_players!({}) }.to raise_error('Cannot change players for an assigned match')
      end
    end
  end

  describe '#players_assigned?' do
    subject { kartalytics_match.players_assigned? }

    before do
      kartalytics_match.update(player_one: nil, player_two: nil, player_three: nil, player_four: nil)
    end

    context 'without players' do
      it { is_expected.to be_falsey }
    end

    context 'with two players' do
      before do
        kartalytics_match.update(player_one: player_one, player_two: player_two)
      end

      it { is_expected.to be_falsey }
    end

    context 'with three players' do
      context 'when player_four is nil' do
        before do
          kartalytics_match.update(player_one: player_one, player_two: player_two, player_three: player_three)
        end

        context 'when player_count is nil' do
          let(:player_count) { nil }

          it { is_expected.to be_truthy }
        end

        context 'when player_count is 3' do
          let(:player_count) { 3 }

          it { is_expected.to be_truthy }
        end

        context 'when player_count is 4' do
          let(:player_count) { 4 }

          it { is_expected.to be_falsey }
        end
      end

      context 'when player_four is present' do
        before do
          kartalytics_match.update(player_one: player_one, player_two: player_two, player_four: player_three)
        end

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#started?' do
    subject { kartalytics_match.started? }

    context 'without races' do
      it { is_expected.to be_falsey }
    end

    context 'with races' do
      before do
        KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first)
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#finalize!' do
    let(:event) { { data: { player_one: { position: 9 }, player_two: { position: 12 }, player_three: { position: 4 } } }.with_indifferent_access }

    subject(:finalize!) { kartalytics_match.finalize!(event) }

    before do
      allow(::Slack).to receive(:notify)
    end

    it 'sets the final postiions' do
      finalize!

      expect(kartalytics_match.player_one_position).to eq(9)
      expect(kartalytics_match.player_two_position).to eq(12)
      expect(kartalytics_match.player_three_position).to eq(4)
      expect(::Slack).not_to have_received(:notify)
    end

    it 'destroys unfinished races' do
      unfinished_race = KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first, status: 'in_progress')
      KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first, status: 'finished')
      KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first, started_at: Time.zone.now, player_one_finished_at: Time.zone.now)

      race_with_snaphots = KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first, status: 'in_progress')
      20.times { FactoryBot.create(:kartalytics_race_snapshot, race: race_with_snaphots) }

      expect { finalize! }.to change { kartalytics_match.races.count }.by(-1)
      expect { unfinished_race.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'with 4+ races' do
      before do
        4.times do
          KartalyticsRace.create!(match: kartalytics_match, course: KartalyticsCourse.first, status: 'finished')
        end

        finalize!
      end

      context 'when the match is assigned' do
        it 'does not publish to slack' do
          expect(::Slack).not_to have_received(:notify).with(/:kart: result/)
        end

        it 'creates entered matches and races' do
          expect(kartalytics_match.entered_matches.count).to eq(3)
          expect(kartalytics_match.entered_races.count).to eq(12)
        end
      end

      context 'when the match is not assigned' do
        let(:match) { nil }

        it 'publishes to slack' do
          expect(::Slack).to have_received(:notify).once.with(":kart: result player_one player_two player_three")
        end
      end
    end
  end

  describe '#count_matches_in_a_row' do
    let(:other_player) { FactoryBot.create(:player, name: 'player_other') }

    def create_match(player_one:, player_two:, player_three:)
      match = FactoryBot.create(:match, players_in_order: [
        player_three.name,
        player_two.name,
        player_one.name,
      ].join(','))

      FactoryBot.create(:kartalytics_match,
        created_at: 6.minutes.ago,
        match: match,
        status: status,
        player_count: 3,
        player_one: player_one,
        player_one_score: 75,
        player_one_order: 2,
        player_one_position: 3,
        player_two: player_two,
        player_two_score: 75,
        player_two_order: 1,
        player_two_position: 2,
        player_three: player_three,
        player_three_score: 90,
        player_three_order: 0,
        player_three_position: 1,
        player_four_order: 3,
        player_four_position: nil,
      )
    end

    context 'with some matches in a row' do
      before do
        # it's reverse chronological, so, starting at the bottom:
        # 4 matches with p1, p2, p3, then 1 match with p1, p2, other, then 2 more with p1, p2, p3
        create_match(player_one: player_one, player_two: player_two, player_three: player_three)
        create_match(player_one: player_one, player_two: player_two, player_three: player_three)
        create_match(player_one: player_one, player_two: player_two, player_three: other_player)
        create_match(player_one: player_one, player_two: player_two, player_three: player_three)
        create_match(player_one: player_one, player_two: player_two, player_three: player_three)
        create_match(player_one: player_one, player_two: player_two, player_three: player_three)
        create_match(player_one: player_one, player_two: player_two, player_three: player_three)

        # instantiate the kartalytics_match after we've created the previous match
        kartalytics_match
      end

      # 5 is the previous 4, and this one
      it 'should only have 5 match in a row' do
        expect(kartalytics_match.count_matches_in_a_row).to eq(5)
      end
    end

    context 'with no matches in a row' do
      before do
        create_match(player_one: player_one, player_two: player_two, player_three: other_player)

        # instantiate the kartalytics_match after we've created the previous match
        kartalytics_match
      end

      it 'should only have 1 match in a row' do
        expect(kartalytics_match.count_matches_in_a_row).to eq(1)
      end
    end
  end
end
