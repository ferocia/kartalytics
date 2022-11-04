require 'rails_helper'

describe KartalyticsRace, type: :model do

  describe "update_course_info!" do
    before do
      FactoryBot.create(:kartalytics_course, name: "foo")
      FactoryBot.create(:kartalytics_course, name: "bar")
    end
    let(:race) { FactoryBot.create(:kartalytics_race) }
    context 'on the first detection of a course' do
      it 'should set the course' do
        race.update_course_info!(course_name: "foo")
        race.reload
        expect(race.course.name).to eq("foo")
      end
    end
    context 'on the multiple detection of a course' do
      it 'should set the course that was detected the most' do
        race.update_course_info!(course_name: "bar")
        race.update_course_info!(course_name: "bar")
        race.update_course_info!(course_name: "foo")
        race.reload
        expect(race.course.name).to eq("bar")
      end
    end

    context 'with a base64 image' do
      let(:image_base64) { 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7' }
      let(:image_base64_2) { 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=' }

      it 'sets the detected image' do
        race.update_course_info!(course_name: 'bar', image_base64: image_base64)
        expect(race.detected_image_base64).to eq(image_base64)
      end

      it 'only updates the detected image when the course changes' do
        race.update_course_info!(course_name: 'bar', image_base64: image_base64)
        race.update_course_info!(course_name: 'bar')
        race.update_course_info!(course_name: 'foo', image_base64: image_base64_2)
        expect(race.course.name).to eq('bar')
        expect(race.detected_image_base64).to eq(image_base64)
      end
    end
  end

  describe '#update_course' do
    let(:course_1) { KartalyticsCourse.create(name: 'Paris Promenade (Tour)') }
    let(:course_2) { KartalyticsCourse.create(name: 'Coconut Mall (Wii)') }
    let(:kartalytics_match) { FactoryBot.create(:kartalytics_match, match: FactoryBot.create(:match)) }
    let(:race) { FactoryBot.create(:kartalytics_race, course: course_1, match: kartalytics_match) }

    before do
      FactoryBot.create(:entered_race, race: race, course: course_1, race_time: 40)
    end

    it 'updates the course and updates player associations on the match' do
      expect(race.course).to eq(course_1)
      expect(race.entered_races.first.course).to eq(course_1)
      race.update_course(course_2)
      expect(race.course).to eq(course_2)
      expect(race.entered_races.first.course).to eq(course_2)
    end
  end

  describe 'after create' do
    let(:course_1) { KartalyticsCourse.create(name: 'Paris Promenade (Tour)') }
    let(:course_2) { KartalyticsCourse.create(name: 'Coconut Mall (Wii)') }
    let(:players) {{
      player_one:  FactoryBot.create(:player, name: 'Baby Peach'),
      player_two:  FactoryBot.create(:player, name: 'Toadette'),
      player_three:  FactoryBot.create(:player, name: 'Bowser Jr.'),
      player_four:  FactoryBot.create(:player, name: 'Donkey Kong'),
    }}
    let(:match) { FactoryBot.create(:kartalytics_match, match: FactoryBot.create(:match), **players) }

    it 'posts to slack on the first race' do
      expect(Slack).to receive(:notify).with(':red_shell: Donkey Kong Baby Peach Toadette Bowser Jr. are starting a game :green_shell:')

      FactoryBot.create(:kartalytics_race, course: course_1, match: match)
    end

    it 'does not post to slack on the second race' do
      FactoryBot.create(:kartalytics_race, course: course_1, match: match)

      expect(Slack).to_not receive(:notify).with(':red_shell: Donkey Kong Baby Peach Toadette Bowser Jr. are starting a game :green_shell:')
      FactoryBot.create(:kartalytics_race, course: course_2, match: match)
    end

    context 'for two matches in a row' do
      before do
        # don't post to slack
        allow(Slack).to receive(:notify)

        # previous match
        m = FactoryBot.create(:kartalytics_match,
          match: FactoryBot.create(:match),
          **players)

        FactoryBot.create(:kartalytics_race, course: course_1, match: m)
      end

      it 'posts the correct message to slack' do
        expect(Slack).to receive(:notify).with(':red_shell: Donkey Kong Baby Peach Toadette Bowser Jr. are doubling down :green_shell:')

        FactoryBot.create(:kartalytics_race, course: course_1, match: match)
      end
    end
  end

  describe "to_chart_json" do
    let!(:course) { KartalyticsCourse.create(name: "Moo Moo Meadows") }
    let!(:entered_race) { FactoryBot.create(:entered_race, course: course) }
    let(:race) { FactoryBot.create(
      :kartalytics_race,
      started_at: 8.minutes.ago,
      player_one_finished_at: 6.minutes.ago,
      player_two_finished_at: 5.minutes.ago,
      player_three_finished_at: 2.minutes.ago,
    ) }
    let(:players) { race.to_chart_json[:players] }

    before do
      Timecop.freeze
      race.update_course_info!(course_name: "Moo Moo Meadows")
    end

    it "returns player race times" do
      expect(players[0][:race_time]).to eq(120.0)
      expect(players[1][:race_time]).to eq(180.0)
      expect(players[2][:race_time]).to eq(360.0)
      expect(players[3][:race_time]).to eq(nil)
    end

    it "returns player deltas" do
      expect(players[0][:delta]).to eq(nil)
      expect(players[1][:delta]).to eq("+60.0s")
      expect(players[2][:delta]).to eq("+240.0s")
      expect(players[3][:delta]).to eq(nil)
    end

    context "when course record is not beaten" do
      before do
        entered_race.update(race_time: 30)
        race.reload
      end

      it "does not return any course records set" do
        expect(players[0][:course_record_set]).to be_falsey
        expect(players[1][:course_record_set]).to be_falsey
        expect(players[2][:course_record_set]).to be_falsey
        expect(players[3][:course_record_set]).to be_falsey
      end
    end

    context "when course record is beaten" do
      before do
        entered_race.update(race_time: 300)
        race.reload
      end

      it "returns course record set for one player only" do
        expect(players[0][:course_record_set]).to be_truthy
        expect(players[1][:course_record_set]).to be_falsey
        expect(players[2][:course_record_set]).to be_falsey
        expect(players[3][:course_record_set]).to be_falsey
      end
    end

    context "when course record is nil" do
      it "returns course record set for one player only" do
        expect(players[0][:course_record_set]).to be_truthy
        expect(players[1][:course_record_set]).to be_falsey
        expect(players[2][:course_record_set]).to be_falsey
        expect(players[3][:course_record_set]).to be_falsey
      end
    end
  end

  describe '#any_players_finished?' do
    subject { race.any_players_finished? }

    context 'when no players are finished' do
      let(:race) { FactoryBot.create(:kartalytics_race) }

      it { is_expected.to be false }
    end

    context 'when a player has finished' do
      let(:race) { FactoryBot.create(:kartalytics_race, player_two_finished_at: 1.second.ago) }

      it { is_expected.to be true }
    end
  end

  describe '#update_results!' do
    let(:event) { { data: { } }.with_indifferent_access }
    let(:player_one) { FactoryBot.create(:player, name: 'dbs') }
    let(:player_two) { FactoryBot.create(:player, name: 'jack') }
    let(:player_one_finished_at) { 15.seconds.ago }
    let(:player_two_finished_at) { 25.seconds.ago }
    let(:course) { KartalyticsCourse.create(name: 'Paris Promenade (Tour)') }
    let(:match) { FactoryBot.create(:kartalytics_match, player_one: player_one, player_two: player_two) }
    let(:race) do
      FactoryBot.create(
        :kartalytics_race,
        course: course,
        match: match,
        started_at: 60.seconds.ago,
        player_one_finished_at: player_one_finished_at,
        player_two_finished_at: player_two_finished_at,
        player_three_finished_at: 22.seconds.ago,
      )
    end

    before do
      Timecop.freeze
      allow(::Slack).to receive(:notify).once
    end

    after do
      Timecop.return
    end

    context 'on a course with no known WR' do
      context 'when a player beats a record they already hold' do
        before do
          FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 65)
        end

        it 'posts to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has improved their record on Paris Promenade (Tour) with a time of 35.0s (-30.0s)')
        end
      end

      context 'when multiple players beat the record' do
        before do
          FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 85)
        end

        it 'posts the fastest record to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has improved their record on Paris Promenade (Tour) with a time of 35.0s (-50.0s)')
        end

        context 'with the same time' do
          let(:player_one_finished_at) { 25.seconds.ago }
          let(:player_two_finished_at) { 25.seconds.ago }

          context 'when player_one beats player_two' do
            let(:event) { { data: { player_one: { position: 1 }, player_two: { position: 2 } } }.with_indifferent_access }

            it 'gives the record to player_one' do
              race.update_results!(event)
              expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! dbs has stolen Paris Promenade (Tour) from jack with a time of 35.0s (-50.0s)')
            end
          end

          context 'when player_two beats player_one' do
            let(:event) { { data: { player_one: { position: 2 }, player_two: { position: 1 } } }.with_indifferent_access }

            it 'gives the record to player_two' do
              race.update_results!(event)
              expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has improved their record on Paris Promenade (Tour) with a time of 35.0s (-50.0s)')
            end
          end
        end
      end

      context 'when a player beats someone elses record' do
        before do
          FactoryBot.create(:entered_race, course: course, player: player_one, race_time: 65)
        end

        it 'posts to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has stolen Paris Promenade (Tour) from dbs with a time of 35.0s (-30.0s)')
        end

        context 'when called multiple times' do
          it 'does not spam slack' do
            race.update_results!(event)
            race.update_results!(event)
            expect(::Slack).to have_received(:notify).once
          end
        end

        context 'when players are not assigned' do
          before do
            match.update(player_one: nil, player_two: nil)
          end

          it 'does not post the record to slack' do
            race.update_results!(event)
            expect(::Slack).not_to have_received(:notify)
          end
        end
      end

      context 'when a course is played for the first time' do
        it 'posts to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has set the record for Paris Promenade (Tour) with a time of 35.0s')
        end
      end

      context 'when a record is not set' do
        before do
          FactoryBot.create(:entered_race, course: course, race_time: 35)
        end

        it 'does not post to slack' do
          race.update_results!(event)
          expect(::Slack).not_to have_received(:notify)
        end
      end

      context 'without any finish times' do
        let(:race) { FactoryBot.create(:kartalytics_race, course: course, match: match) }

        it 'does not post to slack' do
          race.update_results!(event)
          expect(::Slack).not_to have_received(:notify)
        end
      end
    end

    context 'on a course with a known WR' do
      let(:course) { KartalyticsCourse.create(name: 'Paris Promenade (Tour)', world_record_time: 20.22) }
      let(:race) do
        FactoryBot.create(
          :kartalytics_race,
          course: course,
          match: match,
          started_at: 60.seconds.ago,
          player_one_finished_at: player_one_finished_at,
          player_two_finished_at: player_two_finished_at,
          player_three_finished_at: 22.seconds.ago,
        )
      end

      context 'when a player beats a record they already hold' do
        before do
          FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 65)
        end

        it 'posts to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has improved their record on Paris Promenade (Tour) with a time of 35.0s (-30.0s) WR gap: 44.78s :arrow_lower_right: 14.78s')
        end
      end

      context 'when multiple players beat the record' do
        before do
          FactoryBot.create(:entered_race, course: course, player: player_two, race_time: 85)
        end

        it 'posts the fastest record to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has improved their record on Paris Promenade (Tour) with a time of 35.0s (-50.0s) WR gap: 64.78s :arrow_lower_right: 14.78s')
        end

        context 'with the same time' do
          let(:player_one_finished_at) { 25.seconds.ago }
          let(:player_two_finished_at) { 25.seconds.ago }

          context 'when player_one beats player_two' do
            let(:event) { { data: { player_one: { position: 1 }, player_two: { position: 2 } } }.with_indifferent_access }

            it 'gives the record to player_one' do
              race.update_results!(event)
              expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! dbs has stolen Paris Promenade (Tour) from jack with a time of 35.0s (-50.0s) WR gap: 64.78s :arrow_lower_right: 14.78s')
            end
          end

          context 'when player_two beats player_one' do
            let(:event) { { data: { player_one: { position: 2 }, player_two: { position: 1 } } }.with_indifferent_access }

            it 'gives the record to player_two' do
              race.update_results!(event)
              expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has improved their record on Paris Promenade (Tour) with a time of 35.0s (-50.0s) WR gap: 64.78s :arrow_lower_right: 14.78s')
            end
          end
        end
      end

      context 'when a player beats someone elses record' do
        before do
          FactoryBot.create(:entered_race, course: course, player: player_one, race_time: 65)
        end

        it 'posts to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has stolen Paris Promenade (Tour) from dbs with a time of 35.0s (-30.0s) WR gap: 44.78s :arrow_lower_right: 14.78s')
        end

        context 'when called multiple times' do
          it 'does not spam slack' do
            race.update_results!(event)
            race.update_results!(event)
            expect(::Slack).to have_received(:notify).once
          end
        end

        context 'when players are not assigned' do
          before do
            match.update(player_one: nil, player_two: nil)
          end

          it 'does not post the record to slack' do
            race.update_results!(event)
            expect(::Slack).not_to have_received(:notify)
          end
        end
      end

      context 'when a course is played for the first time' do
        it 'posts to slack' do
          race.update_results!(event)
          expect(::Slack).to have_received(:notify).once.with(':sprakcle: NEW COURSE RECORD! jack has set the record for Paris Promenade (Tour) with a time of 35.0s :sprakcle: WR gap: 14.78s')
        end
      end

      context 'when a record is not set' do
        before do
          FactoryBot.create(:entered_race, course: course, race_time: 35)
        end

        it 'does not post to slack' do
          race.update_results!(event)
          expect(::Slack).not_to have_received(:notify)
        end
      end

      context 'without any finish times' do
        let(:race) { FactoryBot.create(:kartalytics_race, course: course, match: match) }

        it 'does not post to slack' do
          race.update_results!(event)
          expect(::Slack).not_to have_received(:notify)
        end
      end
    end
  end
end
