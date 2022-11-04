require 'rails_helper'

describe KartalyticsCourse, type: :model do
  describe "top_players" do
    let(:p1) { FactoryBot.create(:player, name: "p1") }
    let(:p2) { FactoryBot.create(:player, name: "p2")}
    let(:p3) { FactoryBot.create(:player, name: "p3")}
    let(:course) { FactoryBot.create(:kartalytics_course) }

    before do
      5.times do
        FactoryBot.create(:entered_race, course: course, player: p1, final_position: 1)
        FactoryBot.create(:entered_race, course: course, player: p3, final_position: 1)
      end

      FactoryBot.create(:entered_race, course: course, player: p1, final_position: 2)
      FactoryBot.create(:entered_race, course: course, player: p2, final_position: 1)
    end

    it 'returns players ordered by -min(races, 5) then ratio' do
      expect(course.top_players).to eq(
        [
          {games: 5, player_name: "p3", ratio: 1.0, wins: 5},
          {games: 6, player_name: "p1", ratio: 0.83, wins: 5},
          {games: 1, player_name: "p2", ratio: 1.0, wins: 1},
        ]
      )
    end

    context 'when scoped to an array of players' do
      it 'returns only those players' do
        expect(course.top_players(scoped_players: [p1, p2])).to eq(
          [
            {games: 6, player_name: 'p1', ratio: 0.83, wins: 5},
            {games: 1, player_name: 'p2', ratio: 1.0, wins: 1},
          ]
        )
      end
    end
  end

  describe '#top_records' do
    let(:p1) { FactoryBot.create(:player, name: 'p1') }
    let(:p2) { FactoryBot.create(:player, name: 'p2')}
    let(:p3) { FactoryBot.create(:player, name: 'p3')}
    let(:course) { FactoryBot.create(:kartalytics_course) }

    before do
      FactoryBot.create(:entered_race, course: course, player: p3, race_time: 40)
      FactoryBot.create(:entered_race, course: course, player: p2, race_time: 30)
      FactoryBot.create(:entered_race, course: course, player: p1, race_time: 30)
      FactoryBot.create(:entered_race, course: course, player: p2, race_time: 35)
    end

    it 'returns players ordered by fastest time' do
      expect(course.top_records).to eq(
        [
          {player_name: 'p2', race_time: 30.0},
          {player_name: 'p1', race_time: 30.0},
          {player_name: 'p2', race_time: 35.0},
          {player_name: 'p3', race_time: 40.0},
        ]
      )
    end

    context 'when uniq' do
      it 'returns each player only once' do
        expect(course.top_records(uniq: true)).to eq(
          [
            {player_name: 'p2', race_time: 30.0},
            {player_name: 'p1', race_time: 30.0},
            {player_name: 'p3', race_time: 40.0},
          ]
        )
      end
    end

    context 'when scoped to an array of players' do
      it 'returns only those players' do
        expect(course.top_records(scoped_players: [p1, p2], uniq: true)).to eq(
          [
            {player_name: 'p2', race_time: 30.0},
            {player_name: 'p1', race_time: 30.0},
          ]
        )
      end
    end
  end

  describe 'record_set?' do
    let(:name) { 'Moo Moo Meadows' }
    let(:best_time) { 60 }
    let(:course) { FactoryBot.create(:kartalytics_course, name: name) }
    let!(:entered_race) { FactoryBot.create(:entered_race, course: course, race_time: best_time) }

    subject { course.record_set?(new_time) }

    context 'when the old time is nil' do
      let(:best_time) { nil }
      let(:new_time) { 30 }

      it { is_expected.to be true }
    end

    context 'when the new time is less than the old time' do
      let(:new_time) { 30 }

      it { is_expected.to be true }
    end

    context 'when the new time is nil' do
      let(:new_time) { nil }

      it { is_expected.to be false }
    end

    context 'when the new time is under threshold' do
      let(:new_time) { 29 }

      it { is_expected.to be false }
    end

    context 'when the new time is greater than the old time' do
      let(:new_time) { 61 }

      it { is_expected.to be false }
    end

    context 'when the new time is equal to the old time' do
      let(:new_time) { 60 }

      it { is_expected.to be false }
    end

    context 'when the course is unknown' do
      let(:name) { 'Unknown Course' }
      let(:new_time) { 30 }

      it { is_expected.to be false }
    end
  end

  describe '#record_delta' do
    let(:name) { 'Moo Moo Meadows' }
    let(:best_time) { 60 }
    let(:course) { FactoryBot.create(:kartalytics_course, name: name) }

    subject { course.record_delta(new_time) }

    before do
      FactoryBot.create(:entered_race, course: course, race_time: best_time)
    end

    context 'when the old time is nil' do
      let(:best_time) { nil }
      let(:new_time) { 30 }

      it { is_expected.to be_nil }
    end

    context 'when the new time is less than the old time' do
      let(:new_time) { 30 }

      it { is_expected.to eq(-30.0) }
    end

    context 'when the new time is nil' do
      let(:new_time) { nil }

      it { is_expected.to be_nil }
    end

    context 'when the new time is greater than the old time' do
      let(:new_time) { 61 }

      it { is_expected.to eq(1.0) }
    end

    context 'when the course is unknown' do
      let(:name) { 'Unknown Course' }
      let(:new_time) { 30 }

      it { is_expected.to be_nil }
    end
  end

  describe '#pb_set_for?' do
    let(:name) { 'Moo Moo Meadows' }
    let(:best_time) { 63 }
    let(:course) { FactoryBot.create(:kartalytics_course, name: name) }
    let(:player) { FactoryBot.create(:player, name: 'steve') }

    subject { course.pb_set_for?(player, new_time) }

    before do
      FactoryBot.create(:entered_race, course: course, player: player, race_time: best_time)

      player_two = FactoryBot.create(:player, name: 'dbs')
      FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 20)
      FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 70)
    end

    context 'when the old time is nil' do
      let(:best_time) { nil }
      let(:new_time) { 30 }

      it { is_expected.to be true }
    end

    context 'when the new time is less than the old time' do
      let(:new_time) { 47 }

      it { is_expected.to be true }
    end

    context 'when the new time is nil' do
      let(:new_time) { nil }

      it { is_expected.to be false }
    end

    context 'when the new time is greater than the old time' do
      let(:new_time) { 64 }

      it { is_expected.to be false }
    end

    context 'when the new time is equal to the old time' do
      let(:new_time) { best_time }

      it { is_expected.to be false }
    end

    context 'when the course is unknown' do
      let(:name) { 'Unknown Course' }
      let(:new_time) { 30 }

      it { is_expected.to be false }
    end
  end

  describe '#pb_delta_for' do
    let(:name) { 'Moo Moo Meadows' }
    let(:best_time) { 72 }
    let(:course) { FactoryBot.create(:kartalytics_course, name: name) }
    let(:player) { FactoryBot.create(:player, name: 'steve') }

    subject { course.pb_delta_for(player, new_time) }

    before do
      FactoryBot.create(:entered_race, course: course, player: player, race_time: best_time)

      player_two = FactoryBot.create(:player, name: 'dbs')
      FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 20)
      FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 70)
    end

    context 'when the old time is nil' do
      let(:best_time) { nil }
      let(:new_time) { 30 }

      it { is_expected.to be_nil }
    end

    context 'when the new time is less than the old time' do
      let(:new_time) { 30 }

      it { is_expected.to eq(-42.0) }
    end

    context 'when the new time is nil' do
      let(:new_time) { nil }

      it { is_expected.to be_nil }
    end

    context 'when the new time is greater than the old time' do
      let(:new_time) { 94 }

      it { is_expected.to eq(22.0) }
    end

    context 'when the course is unknown' do
      let(:name) { 'Unknown Course' }
      let(:new_time) { 30 }

      it { is_expected.to be_nil }
    end
  end
end
