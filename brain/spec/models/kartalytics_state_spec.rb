# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KartalyticsState, type: :model do
  describe 'ingest' do
    context 'for normal operation' do
      let(:last_intro_timestamp) { '2017-07-02T12:09:26.163Z' }
      let(:events) do
        <<-JSON
          [
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:16.273Z"},
            {"event_type":"intro_screen","data":{"course_name":"Unknown Course"},"timestamp":"2017-07-02T12:09:24.783Z"},
            {"event_type":"intro_screen","data":{"course_name":"Big Blue"},"timestamp":"2017-07-02T12:09:25.783Z"},
            {"event_type":"intro_screen","data":{"course_name":"Big Blue"},"timestamp":"#{last_intro_timestamp}"},
            {"event_type":"race_screen","data":{"player_one":{"position":7}},"timestamp":"2017-07-02T12:09:38.273Z"},
            {"event_type":"race_screen","data":{"player_two":{"position":4},"player_three":{"position":3},"player_four":{"position":2}},"timestamp":"2017-07-02T12:09:39.273Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5},"player_two":{"position":4}},"timestamp":"2017-07-02T12:010:41.773Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5,"status":"finish"},"player_two":{"position":4},"player_three":{"position":3},"player_four":{"position":7}},"timestamp":"2017-07-02T12:10:42.273Z"},
            {"event_type":"race_result_screen","data":{"player_one":{"position":1}},"timestamp":"2017-07-02T12:12:01.293Z"},
            {"event_type":"race_result_screen","data":{"player_one":{"position":1},"player_two":{"position":5},"player_three":{"position":8},"player_four":{"position":9}},"timestamp":"2017-07-02T12:12:01.813Z"},
            {"event_type":"race_result_screen","data":{"player_one":{"position":1},"player_two":{"position":5},"player_four":{"position":9}},"timestamp":"2017-07-02T12:12:03.793Z"},
            {"event_type":"match_result_screen","timestamp":"2017-07-02T13:00:26.038Z","data":{"player_two":{"position":5},"player_three":{"position":8},"player_four":{"position":9}}},
            {"event_type":"match_result_screen","timestamp":"2017-07-02T13:00:26.038Z","data":{"player_one":{"position":1},"player_two":{"position":5},"player_three":{"position":8},"player_four":{"position":9}}}
          ]
        JSON
      end

      let(:match) { KartalyticsMatch.last }
      let(:snapshot) { match.races.first.race_snapshots.first }

      it 'should ingest the events and set up appropriate database records' do
        expect do
          JSON.parse(events).each do |event|
            KartalyticsState.ingest(event.with_indifferent_access)
          end
        end.to change { KartalyticsMatch.all.count }.by(1)

        expect(match.player_count).to eq(4)
        expect(match.races.length).to eq(1)
        expect(match.races.first.course.name).to eq('Big Blue')
        expect(match.races.first.course.best_time).to eq(nil)
        expect(match.races.first.detected_courses).to eq('Unknown Course' => 1, 'Big Blue' => 2)
        expect(match.races.first.started_at).to eq(last_intro_timestamp.to_datetime + 8.5.seconds) # ensure started_at is updated on every intro_screen event

        expect(snapshot.player_one_position).to eq(7)
        expect(snapshot.player_two_position).to be_nil

        expect(match.status).to eq('finished')
      end
    end

    context 'for a 3 player match when the analyser detects a 4th player (false positive)' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:16.273Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5},"player_two":{"position":4},"player_three":{"position":1}},"timestamp":"2017-07-02T12:09:38.273Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5},"player_two":{"position":4},"player_three":{"position":1}},"timestamp":"2017-07-02T12:09:39.273Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5},"player_two":{"position":4},"player_three":{"position":1}},"timestamp":"2017-07-02T12:09:40.273Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5},"player_two":{"position":4},"player_three":{"position":1},"player_four":{"position":2}},"timestamp":"2017-07-02T12:09:41.273Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":5},"player_two":{"position":4},"player_three":{"position":1}},"timestamp":"2017-07-02T12:10:42.773Z"},
            {"event_type":"race_result_screen","data":{"player_one":{"position":5},"player_two":{"position":4}},"timestamp":"2017-07-02T12:12:03.793Z"}
          ]
        JSON
      end

      let(:race_result_event) do
        JSON.parse(
          <<-JSON
            {"event_type":"race_result_screen","data":{"player_one":{"position":5},"player_two":{"position":4},"player_three":{"position":2}},"timestamp":"2017-07-02T12:12:04.793Z"}
          JSON
        ).with_indifferent_access
      end

      let(:match) { KartalyticsState.instance.current_match }
      let(:race) { KartalyticsState.instance.current_race }

      it 'sets the player count to 3' do
        JSON.parse(events).each do |event|
          KartalyticsState.ingest(event.with_indifferent_access)
        end

        expect(match.player_count).to eq(3)
        expect(race.status).to eq('in_progress')

        KartalyticsState.ingest(race_result_event)
        expect(race.reload.status).to eq('finished')
      end
    end

    context 'for an abandoned match' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:16.273Z"},
            {"event_type":"intro_screen","data":{"course_name":"Big Blue"},"timestamp":"2017-07-02T12:09:25.783Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":7}},"timestamp":"2017-07-02T12:09:38.273Z"},
            {"event_type":"race_result_screen","data":{"player_one":{"position":1}},"timestamp":"2017-07-02T12:12:01.293Z"}
          ]
        JSON
      end
      let(:main_menu_event) do
        JSON.parse(
          <<-JSON
            {"event_type":"main_menu_screen","timestamp":"2017-07-02T12:09:16.273Z"}
          JSON
        ).with_indifferent_access
      end

      let(:match) { KartalyticsMatch.last }

      it 'should ingest the events and set up appropriate database records' do
        expect do
          JSON.parse(events).each do |event|
            KartalyticsState.ingest(event.with_indifferent_access)
          end
        end.to change { KartalyticsMatch.all.count }.by(1)

        expect(match.status).to eq('in_progress')

        expect do
          KartalyticsState.ingest(main_menu_event)
        end.not_to change { KartalyticsMatch.all.count }

        expect(KartalyticsState.instance.current_match).to be_nil
        expect(match.reload.status).to eq('abandoned')
      end

      context 'without any races' do
        let(:events) do
          <<-JSON
            [
              {"event_type":"main_menu_screen","timestamp":"2017-07-02T12:09:16.273Z"},
              {"event_type":"select_character_screen","timestamp":"2017-07-02T12:09:17.273Z"},
              {"event_type":"race_screen","data":{"player_one":{"position":7}},"timestamp":"2017-07-02T12:09:38.273Z"}
            ]
          JSON
        end

        it 'destroys the match' do
          expect do
            JSON.parse(events).each do |event|
              KartalyticsState.ingest(event.with_indifferent_access)
            end
          end.to change { KartalyticsMatch.all.count }.by(1)

          expect do
            KartalyticsState.ingest(main_menu_event)
          end.to change { KartalyticsMatch.all.count }.by(-1)

          expect(KartalyticsState.instance.current_match).to be_nil
        end
      end
    end

    context 'when the race result screen is missed' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"race_screen","data":{"player_one":{"position":7,"status":"finish"}},"timestamp":"2017-07-02T12:09:38.273Z"},
            {"event_type":"race_screen","data":{"player_two":{"position":1,"status":"finish"},"player_three":{"position":4}},"timestamp":"2017-07-02T12:09:38.373Z"},
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:40.273Z"}
          ]
        JSON
      end

      let(:race) { KartalyticsRace.last }

      before do
        expect do
          JSON.parse(events).each do |event|
            KartalyticsState.ingest(event.with_indifferent_access)
          end
        end.to change { KartalyticsMatch.all.count }.by(1)
      end

      it 'finalizes the race' do
        expect(KartalyticsState.instance.current_race).to be_nil
      end

      context 'when no players are finished' do
        let(:events) do
          <<-JSON
            [
              {"event_type":"race_screen","data":{"player_one":{"position":7}},"timestamp":"2017-07-02T12:09:38.273Z"},
              {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:40.273Z"}
            ]
          JSON
        end

        it 'does not finalize the race' do
          expect(KartalyticsState.instance.current_race).to eq(race)
        end
      end
    end

    context 'when character selection is abandoned and resumed' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"select_character_screen","timestamp":"2022-06-27T13:00:00+10:00"}
          ]
        JSON
      end
      let(:intro_screen_event) do
        JSON.parse(
          <<-JSON
            {"event_type":"intro_screen","data":{"course_name":"Dry Dry Desert (GameCube)", "image_base64":"R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"},"timestamp":"2022-06-29T13:00:00.000+10:00"}
          JSON
        ).with_indifferent_access
      end
      let(:yesterday) { Time.local(2022, 06, 27) }
      let(:today) { Time.local(2022, 06, 28) }

      before do
        Timecop.freeze(yesterday)
      end

      after do
        Timecop.return
      end

      it 'updates created_at to the current time' do
        expect do
          JSON.parse(events).each do |event|
            KartalyticsState.ingest(event.with_indifferent_access)
          end
        end.to change { KartalyticsMatch.all.count }.by(1)

        expect(KartalyticsState.instance.current_match.created_at).to eq(yesterday)
        Timecop.freeze(today)
        KartalyticsState.ingest(intro_screen_event)
        expect(KartalyticsState.instance.current_match.created_at).to eq(today)
      end
    end

    context 'when the previous race is not finalised' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:16.273Z"},
            {"event_type":"intro_screen","data":{"course_name":"Big Blue"},"timestamp":"2017-07-02T12:09:25.783Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":7}},"timestamp":"2017-07-02T12:09:38.273Z"}
          ]
        JSON
      end
      let(:intro_screen_event) do
        JSON.parse(
          <<-JSON
            {"event_type":"intro_screen","data":{"course_name":"Dry Dry Desert (GameCube)", "image_base64":"R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"},"timestamp":"2017-07-02T12:12:22.783Z"}
          JSON
        ).with_indifferent_access
      end

      it 'should create a new race' do
        expect do
          JSON.parse(events).each do |event|
            KartalyticsState.ingest(event.with_indifferent_access)
          end
        end.to change { KartalyticsMatch.all.count }.by(1)

        expect(KartalyticsState.instance.current_match.races.length).to eq(1)
        expect(KartalyticsState.instance.current_match.races.first).not_to be_finished
        KartalyticsState.ingest(intro_screen_event)
        expect(KartalyticsState.instance.current_match.races.length).to eq(2)

        expect(KartalyticsState.instance.current_race.course.name).to eq('Dry Dry Desert (GameCube)')
        expect(KartalyticsState.instance.current_race.detected_image_base64).to eq('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7')
      end
    end
  end

  describe '#associate_players' do
    subject(:associate_players) { KartalyticsState.instance.associate_players(data: data) }

    def current_match
      KartalyticsState.instance.current_match
    end

    before do
      KartalyticsState.instance.update(current_match: KartalyticsMatch.create!)
      associate_players
    end

    context 'with valid players' do
      let(:data) { { player_one: { name: 'samii' }, player_two: { name: 'langers' }, player_three: { name: 'andrew' }, player_four: { name: 'carson' } } }

      it 'associates all players' do
        expect(current_match.player_names_in_order).to eq(['samii', 'langers', 'andrew', 'carson'])
      end
    end

    context 'with invalid players' do
      let(:data) { { player_one: { name: 'raj' }, player_two: { name: 'mike' }, player_three: { name: 'tom' }, player_four: { name: 'null420' } } }

      it 'silently ignores invalid players' do
        expect(current_match.player_names_in_order).to eq(['raj', 'mike', 'tom'])
      end
    end

    context 'when reassigned from 4 to 3 players' do
      let(:data) { { player_one: { name: 'samii' }, player_two: { name: 'langers' }, player_three: { name: 'andrew' }, player_four: { name: 'carson' } } }

      it 'clears the previous associations' do
        expect(current_match.player_names_in_order).to eq(['samii', 'langers', 'andrew', 'carson'])
        KartalyticsState.instance.associate_players(data: { player_one: { name: 'langers' }, player_two: { name: 'samii' }, player_three: { name: 'andrew' } })
        expect(current_match.player_names_in_order).to eq(['langers', 'samii', 'andrew'])
      end
    end

    context 'because christian borked the qr codes' do
      let(:data) { { player_one: { name: 'http://josh' }, player_two: { name: 'https://gt' }, player_three: { name: 'wernah' }, player_four: { name: 'null' } } }

      it 'strips protocol from player name 🤦‍♀️' do
        expect(current_match.player_names_in_order).to eq(['josh', 'gt', 'wernah'])
      end
    end
  end

  describe 'associate_match' do
    let(:state) { KartalyticsState.first_or_create }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'when a match is finished and it cannot be associated' do
      let!(:kartalytics_match) do
        KartalyticsMatch.create!(
          status: 'finished'
        ).tap do |m|
          m.update(created_at: 10.minutes.ago)
        end
      end

      before do
        KartalyticsState.instance.update current_match: kartalytics_match

        Match.create_for!('123', %w[mike jared josh langers])
        kartalytics_match.reload
      end

      it 'should not assign the match' do
        expect(kartalytics_match).to_not be_assigned
      end
    end
    context 'when a match is finished and can be associated' do
      let!(:kartalytics_match) do
        FactoryBot.create(:kartalytics_match).tap do |m|
          m.update(created_at: 10.minutes.ago)
        end
      end

      let(:course) { KartalyticsCourse.create(name: 'Moo Moo Meadows') }

      let!(:kartalytics_race) do
        KartalyticsRace.create!(
          match:                    kartalytics_match,
          course:                   course,
          started_at:               7.minutes.ago,
          player_one_position:      3,
          player_two_position:      7,
          player_three_position:    5,
          player_four_position:     12,
          player_one_finished_at:   6.minutes.ago,
          player_two_finished_at:   6.minutes.ago,
          player_three_finished_at: nil,
          player_four_finished_at:  6.minutes.ago,
          player_one_score:         12,
          player_two_score:         12,
          player_three_score:       12,
          player_four_score:        12
        )
      end

      let!(:new_abandoned_match) do
        KartalyticsMatch.create!(status: 'abandoned').tap do |m|
          m.update(created_at: 5.minutes.ago)
        end
      end

      let!(:old_match) do
        KartalyticsMatch.create!.tap do |m|
          m.update(created_at: 20.minutes.ago)
        end
      end

      before do
        KartalyticsState.instance.update current_match: kartalytics_match

        Match.create_for!('123', %w[mike jared josh langers])
        kartalytics_match.reload
      end

      it 'should associate the match and create records for the players' do
        expect(kartalytics_match).to be_assigned

        # Match order [4, 1, 2, 3]
        expect(kartalytics_match.player_one.name).to eq('jared')
        expect(kartalytics_match.player_two.name).to eq('josh')
        expect(kartalytics_match.player_three.name).to eq('langers')
        expect(kartalytics_match.player_four.name).to eq('mike')
      end

      it 'should set up entered matches for the players' do
        player = kartalytics_match.player_one
        expect(player.entered_matches.length).to eq(1)
        expect(player.entered_matches.last.final_position).to eq(4)
        expect(player.entered_matches.last.final_score).to eq(10)
      end

      it 'should set up entered races for the players' do
        player = kartalytics_match.player_one
        expect(player.entered_races.length).to eq(1)
        expect(player.entered_races.last.final_position).to eq(3)
        expect(player.entered_races.last.race_time).to eq(60.0)
      end

      it 'should not add a race time when the race time was not determined' do
        player = kartalytics_match.player_three

        expect(player.entered_races.last.race_time).to be_nil
      end

      it 'should set the course record' do
        expect(kartalytics_match.races.first.course.best_time).to eq(60.0)
      end
    end
  end
end
