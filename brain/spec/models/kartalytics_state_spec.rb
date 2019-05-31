# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KartalyticsState, type: :model do
  describe 'ingest' do
    context 'for normal operation' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:16.273Z"},
            {"event_type":"intro_screen","data":{"course_name":"Big Blue"},"timestamp":"2017-07-02T12:09:25.783Z"},
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
        expect(match.races.first.course.best_time).to eq(66.49)

        expect(snapshot.player_one_position).to eq(7)
        expect(snapshot.player_two_position).to be_nil

        expect(match.status).to eq('pending_player_assignment')
      end
    end

    context 'for an abandoned match' do
      let(:events) do
        <<-JSON
          [
            {"event_type":"loading_screen","timestamp":"2017-07-02T12:09:16.273Z"},
            {"event_type":"intro_screen","data":{"course_name":"Big Blue"},"timestamp":"2017-07-02T12:09:25.783Z"},
            {"event_type":"race_screen","data":{"player_one":{"position":7}},"timestamp":"2017-07-02T12:09:38.273Z"}
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
      let(:snapshot) { match.races.first.race_snapshots.first }

      it 'should ingest the events and set up appropriate database records' do
        expect do
          JSON.parse(events).each do |event|
            KartalyticsState.ingest(event.with_indifferent_access)
          end
        end.to change { KartalyticsMatch.all.count }.by(1)

        expect(KartalyticsState.instance.current_match).to be
        KartalyticsState.ingest(main_menu_event)
        expect(KartalyticsState.instance.current_match).to be_nil
      end
    end
  end

  describe 'associate_match' do
    let(:state) { KartalyticsState.first_or_create }

    context 'when a match is finished and it cannot be associated' do
      let!(:kartalytics_match) do
        KartalyticsMatch.create!(
          player_one_score:      10,
          player_two_score:      9,
          player_three_score:    9,
          player_one_position:   4,
          player_two_position:   6,
          player_three_position: 7,
          status:                'pending_player_assignment'
        ).tap do |m|
          m.update_attributes(created_at: 10.minutes.ago)
        end
      end

      before do
        Timecop.freeze
        KartalyticsState.instance.update_attributes current_match: kartalytics_match

        Match.create_for!('1234', %w[mike jared josh langers])
        kartalytics_match.reload
      end

      it 'should not assign the match' do
        expect(kartalytics_match).to_not be_assigned
      end
    end
    context 'when a match is finished and can be associated' do
      let!(:kartalytics_match) do
        KartalyticsMatch.create!(
          player_one_score:      10,
          player_two_score:      9,
          player_three_score:    9,
          player_four_score:     12,
          player_one_position:   4,
          player_two_position:   6,
          player_three_position: 7,
          player_four_position:  2,
          status:                'pending_player_assignment'
        ).tap do |m|
          m.update_attributes(created_at: 10.minutes.ago)
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
          m.update_attributes(created_at: 5.minutes.ago)
        end
      end

      let!(:old_match) do
        KartalyticsMatch.create!.tap do |m|
          m.update_attributes(created_at: 20.minutes.ago)
        end
      end

      before do
        Timecop.freeze
        KartalyticsState.instance.update_attributes current_match: kartalytics_match

        Match.create_for!('1234', %w[mike jared josh langers])
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
        expect(player.entered_races.last.race_time.round(2)).to eq(60.0)
      end

      it 'should not add a race time when the race time was not determined' do
        player = kartalytics_match.player_three

        expect(player.entered_races.last.race_time).to be_nil
      end
    end
  end
end
