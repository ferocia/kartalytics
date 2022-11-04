# frozen_string_literal: true

require 'rails_helper'

describe TrueskillLeaderboardCommand do
  before do
    Match.create_for!('123', %w[samii tom mike chris])
    Match.create_for!('123', %w[jared langers christian wernah])
    Match.create_for!('123', %w[raj gt carson andrew])
  end

  describe '#execute' do
    let(:instance) { described_class.new('123', scoped_players: scoped_players) }

    subject { instance.execute }

    context 'for A league' do
      let(:scoped_players) { %w[samii tom mike chris] }

      it 'scopes leaderboard to A..B leagues' do
        is_expected.to eq(<<~SLACK.strip)
          #|    Name    |Score| ∆  |🎮
           -------- A League --------
          1|chris       | 1977|    | 5
          2|samii 🧯 (1)| 1773|    | 1
          3|tom         | 1762|    | 5
          4|mike        | 1623|    | 2
           -------- B League --------
          5|jared (1)   | 1416|    | 1
          6|raj (1)     | 1324|+428| 4
          7|gt          | 1037|+238| 5
          8|langers     | 1004|    | 1
        SLACK
      end
    end

    context 'for B league' do
      let(:scoped_players) { %w[jared raj gt langers] }

      it 'scopes leaderboard to A..C leagues' do
        is_expected.to eq(<<~SLACK.strip)
          # |    Name    |Score| ∆  |🎮
           -------- A League --------
           1|chris       | 1977|    | 5
           2|samii 🧯 (1)| 1773|    | 1
           3|tom         | 1762|    | 5
           4|mike        | 1623|    | 2
           -------- B League --------
           5|jared (1)   | 1416|    | 1
           6|raj (1)     | 1324|+428| 4
           7|gt          | 1037|+238| 5
           8|langers     | 1004|    | 1
           -------- C League --------
           9|christian   |  524|    | 1
          10|carson      |  350|+350| 1
          11|wernah      | -225|    | 1
          12|andrew      | -330|-330| 1
        SLACK
      end
    end

    context 'for C league' do
      let(:scoped_players) { %w[christian carson wernah andrew] }

      it 'scopes leaderboard to B..C leagues' do
        is_expected.to eq(<<~SLACK.strip)
          # |  Name   |Score| ∆  |🎮
          -------- B League --------
           5|jared (1)| 1416|    | 1
           6|raj (1)  | 1324|+428| 4
           7|gt       | 1037|+238| 5
           8|langers  | 1004|    | 1
          -------- C League --------
           9|christian|  524|    | 1
          10|carson   |  350|+350| 1
          11|wernah   | -225|    | 1
          12|andrew   | -330|-330| 1
        SLACK
      end
    end

    context 'for players in multiple leagues' do
      let(:scoped_players) { %w[jared carson mike] }

      it 'scopes leaderboard to within +/- 1 league' do
        is_expected.to eq(<<~SLACK.strip)
          # |    Name    |Score| ∆  |🎮
           -------- A League --------
           1|chris       | 1977|    | 5
           2|samii 🧯 (1)| 1773|    | 1
           3|tom         | 1762|    | 5
           4|mike        | 1623|    | 2
           -------- B League --------
           5|jared (1)   | 1416|    | 1
           6|raj (1)     | 1324|+428| 4
           7|gt          | 1037|+238| 5
           8|langers     | 1004|    | 1
           -------- C League --------
           9|christian   |  524|    | 1
          10|carson      |  350|+350| 1
          11|wernah      | -225|    | 1
          12|andrew      | -330|-330| 1
        SLACK
      end
    end

    context 'without scoped_players' do
      let(:instance) { described_class.new('123') }

      it 'renders a full leaderboard' do
        is_expected.to eq(<<~SLACK.strip)
          # |    Name    |Score| ∆  |🎮
           -------- A League --------
           1|chris       | 1977|    | 5
           2|samii 🧯 (1)| 1773|    | 1
           3|tom         | 1762|    | 5
           4|mike        | 1623|    | 2
           -------- B League --------
           5|jared (1)   | 1416|    | 1
           6|raj (1)     | 1324|+428| 4
           7|gt          | 1037|+238| 5
           8|langers     | 1004|    | 1
           -------- C League --------
           9|christian   |  524|    | 1
          10|carson      |  350|+350| 1
          11|wernah      | -225|    | 1
          12|andrew      | -330|-330| 1
        SLACK
      end
    end
  end
end
