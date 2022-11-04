# frozen_string_literal: true

require 'rails_helper'

describe SubmitMatchCommand do
  before do
    Match.create_for!('123', %w[samii tom mike chris])
    Match.create_for!('123', %w[jared langers christian wernah])
    Match.create_for!('123', %w[raj gt carson andrew])
  end

  describe '#execute' do
    let(:instance) { described_class.new('123', %w[samii chris tom]) }

    subject { instance.execute }

    it 'scopes leaderboard to within +/- 1 league of match players' do
      is_expected.to eq(<<~SLACK.strip)
        # |  Name   |Score| ∆  |🎮
        -------- A League --------
         1|samii (2)| 2301|+527| 2
         2|chris    | 2103|+126| 6
         3|tom      | 1728| -34| 6
         4|mike     | 1623|    | 2
        -------- B League --------
         5|jared (1)| 1416|    | 1
         6|raj (1)  | 1324|    | 4
         7|gt       | 1037|    | 5
         8|langers  | 1004|    | 1
      SLACK
    end
  end
end
