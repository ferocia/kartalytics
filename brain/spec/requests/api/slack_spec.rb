# frozen_string_literal: true

require 'rails_helper'

describe 'Slack API', type: :request do
  let(:current_time)            { Time.zone.parse('2016-04-01') }
  let(:default_time_since)      { current_time - 1.month }
  let(:default_all_time_since)  { current_time - 10.years }
  before do
    Timecop.freeze(current_time)
  end

  after do
    Timecop.return
  end

  context 'league ABC' do
    describe 'leaderboard' do
      before do
        post '/api/slack', params: { token: 'ABC', text: 'kart leaderboard' }
      end
      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|  Name   |Score| ∆  |🎮
          1|jared (3)| 1393|+227| 3
          2|josh     |  -57| +23| 3
          ```
        SLACK
      end
    end
  end

  context 'league 123' do
    describe 'leaderboard (trueskills)' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart leaderboard_trueskills' }
      end
      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)

        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|    Name    |Score|  ∆  |🎮
           -------- A League --------
          1|chris 🔥 (4)| 2473| +287| 4
          2|tom         | 1369| +107| 4
          3|mike        | 1263|+1263| 1
          4|raj         |  896|     | 3
           -------- B League --------
          5|gt          |  799|  -55| 4
          ```
        SLACK
      end
    end

    describe 'leaderboard (elo)' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart leaderboard_elo' }
      end
      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          +-----------------------------------------------------------------------+
          |                  Leaderboard since about 1 month ago                  |
          +------+----------+-------+--------+--------+--------+---------+--------+
          | Rank | Name     | Score | Change | Played | Streak | Raw ELO | Change |
          +------+----------+-------+--------+--------+--------+---------+--------+
          | 1    | chris 🔥 | 82    | +18    | 4      | 4      | 84      | +19    |
          | 2    | raj      | 12    |        | 3      |        | -33     |        |
          | 3    | mike     | 8     | +8     | 1      |        | 8       | +8     |
          | 4    | tom      | 0     |        | 4      |        | -13     | -6     |
          | 5    | gt       | 0     |        | 4      |        | -45     | -21    |
          +------+----------+-------+--------+--------+--------+---------+--------+
          ```
        SLACK
      end
    end

    describe 'leaderboard (default)' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart leaderboard' }
      end

      specify do
        # Match: chris,gt,tom,raj
        # Match: chris,tom,gt,raj
        # Match: chris,raj,tom,gt
        # Match: chris,mike,tom,gt
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|    Name    |Score|  ∆  |🎮
           -------- A League --------
          1|chris 🔥 (4)| 2473| +287| 4
          2|tom         | 1369| +107| 4
          3|mike        | 1263|+1263| 1
          4|raj         |  896|     | 3
           -------- B League --------
          5|gt          |  799|  -55| 4
          ```
          SLACK
      end
    end

    describe 'undo latest result' do
      context 'successfully' do
        let(:last_match) { Match.last }
        before do
          @original_count = Match.count
          expect(last_match).to be_present
          post '/api/slack', params: { token: '123', text: 'kart undo' }
        end

        specify do
          expect(response).to be_successful
          expect(Match.count).to eq(@original_count - 1)

          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            #|  Name   |Score|  ∆  |🎮
            1|chris (3)| 2187| +231| 3
            2|tom      | 1262|  +38| 3
            3|raj      |  896|+1111| 3
            4|gt       |  853| -176| 3
            ```
          SLACK
        end
      end
    end

    describe 'inspect' do
      context 'successful' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart inspect tom' }
        end
        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            +---------------------------------+
            |            tom vs...            |
            +----------+------+--------+------+
            | Opponent | Wins | Losses | Mojo |
            +----------+------+--------+------+
            | chris    | 0    | 4      | -4   |
            | mike     | 0    | 1      | -1   |
            | raj      | 2    | 1      | 1    |
            | gt       | 3    | 1      | 2    |
            +----------+------+--------+------+
            ```
          SLACK
        end
      end

      context 'with a slack mention' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart inspect <@UT0M666>' }
        end
        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            +---------------------------------+
            |            tom vs...            |
            +----------+------+--------+------+
            | Opponent | Wins | Losses | Mojo |
            +----------+------+--------+------+
            | chris    | 0    | 4      | -4   |
            | mike     | 0    | 1      | -1   |
            | raj      | 2    | 1      | 1    |
            | gt       | 3    | 1      | 2    |
            +----------+------+--------+------+
            ```
          SLACK
        end
      end

      context 'with no data' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart inspect jared' }
        end
        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            +---------------------------------+
            |           jared vs...           |
            +----------+------+--------+------+
            | Opponent | Wins | Losses | Mojo |
            +----------+------+--------+------+
            +---------------------------------+
            ```
          SLACK
        end
      end

      context 'with errors' do
        context 'with missing player name' do
          before do
            post '/api/slack', params: { token: '123', text: 'kart inspect' }
          end
          specify do
            expect(response).to be_successful
            json = JSON.parse(response.body)
            expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              You need to give me a player name 🏄‍♀️
              ```
            SLACK
          end
        end

        context 'with no player found' do
          before do
            post '/api/slack', params: { token: '123', text: 'kart inspect bilbo' }
          end
          specify do
            expect(response).to be_successful
            json = JSON.parse(response.body)
            expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              bilbo doesn't exist 😿
              ```
            SLACK
          end
        end
      end
    end

    describe 'add' do
      context 'successful' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart add roy' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              roy is ready to roll
              ```
            SLACK
        end
      end

      context 'with errors' do
        context 'with missing player name' do
          before do
            post '/api/slack', params: { token: '123', text: 'kart add' }
          end

          specify do
            expect(response).to be_successful
            json = JSON.parse(response.body)
            expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              Name can't be blank
              ```
            SLACK
          end
        end

        context 'when player already exists' do
          before do
            post '/api/slack', params: { token: '123', text: 'kart add tom' }
          end

          specify do
            expect(response).to be_successful
            json = JSON.parse(response.body)
            expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              Name has already been taken
              ```
            SLACK
          end
        end
      end
    end

    describe 'result' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart result mike tom' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|    Name    |Score| ∆  |🎮
           -------- A League --------
          1|chris 🔥 (4)| 2473|    | 4
          2|mike (1)    | 1605|+342| 2
          3|tom         | 1343| -25| 5
          4|raj         |  896|    | 3
           -------- B League --------
          5|gt          |  799|    | 4
          ```
        SLACK
      end
    end

    describe 'extinguishing a fire' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart result mike chris tom' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|   Name    |Score| ∆  |🎮
          -------- A League --------
          1|chris      | 2358|-116| 5
          2|mike 🧯 (1)| 2108|+846| 2
          3|tom        | 1365|  -4| 5
          4|raj        |  896|    | 3
          -------- B League --------
          5|gt         |  799|    | 4
          ```
        SLACK
      end
    end

    describe 'extinguishing a fire with a streak' do
      before do
        FactoryBot.create(:match, league_id: '123', players_in_order: 'chris,mike,tom,raj')
        FactoryBot.create(:match, league_id: '123', players_in_order: 'chris,mike,tom,raj')
        FactoryBot.create(:match, league_id: '123', players_in_order: 'chris,mike,tom,raj')
        FactoryBot.create(:match, league_id: '123', players_in_order: 'chris,mike,tom,raj')

        FactoryBot.create(:match, league_id: '123', players_in_order: 'mike,gt,tom,raj')
        FactoryBot.create(:match, league_id: '123', players_in_order: 'mike,gt,tom,raj')
        FactoryBot.create(:match, league_id: '123', players_in_order: 'mike,gt,tom,raj')
        FactoryBot.create(:match, league_id: '123', players_in_order: 'mike,gt,tom,raj')

        post '/api/slack', params: { token: '123', text: 'kart result mike chris tom gt' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|    Name     |Score| ∆  |🎮
           -------- A League --------
          1|chris        | 2947|-148| 9
          2|mike 🔥🧯 (5)| 2759|+211|10
          3|tom          | 1670| +78|13
          4|gt           | 1628| -61| 9
           -------- B League --------
          5|raj          |  688|    |11
          ```
        SLACK
      end
    end

    describe 'result with invalid player' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart result mike trev' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          Unknown player: 'trev'

          Known players
          -------------
          andrew
          carson
          chris
          christian
          gt
          jared
          josh
          langers
          mike
          raj
          samii
          tom
          wernah
          ```
        SLACK
      end
    end

    describe 'result with duplicate player' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart result mike mike' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          No duplicates please 🤦‍♀️
          ```
        SLACK
      end
    end

    describe 'chart' do
      let(:image_url) do
        'http://chart.apis.google.com/chart?chco=000000,336699,339933,ff0000,cc99cc,cf5910&chf=bg,s,FFFFFF&ch...,AGAA,AAJJ,AAAG&chdl=chris|gt|tom|raj|mike&cht=ls&chs=750x400&chxr=0,24,82|1,8,8|2,0,8|3,0,12|4,0,8'
      end

      before do
        expect(Gchart).to receive(:sparkline) { image_url }
      end

      context 'all' do
        let(:title) { 'Leaderboard: 4 matches from about 1 month ago' }
        before do
          post '/api/slack', params: { token: '123', text: 'kart chart' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['attachments'].count).to eq(1)
          attachment = json['attachments'].first
          expect(attachment['title'].strip).to eq(title)
          expect(attachment['image_url'].strip).to eq(image_url)
        end
      end

      context 'by date' do
        let(:title) { 'Leaderboard: 4 matches from 7 days ago' }
        before do
          post '/api/slack', params: { token: '123', text: 'kart chart since 1 week ago' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['attachments'].count).to eq(1)
          attachment = json['attachments'].first
          expect(attachment['title'].strip).to eq(title)
          expect(attachment['image_url'].strip).to eq(image_url)
        end
      end

      context 'by players' do
        let(:title) { 'Leaderboard: 4 matches from about 1 month ago' }
        context 'by 1 player' do
          let(:image_url) do
            'http://chart.apis.google.com/chart?chco=000000,336699,339933,ff0000,cc99cc,cf5910&chf=bg,s,FFFFFF&chd=s:A9AA&chdl=tom&cht=ls&chs=750x400&chxr=0,0,8'
          end
          before do
            post '/api/slack', params: { token: '123', text: 'kart chart scoped to tom' }
          end

          specify do
            expect(response).to be_successful
            json = JSON.parse(response.body)
            expect(json['attachments'].count).to eq(1)
            attachment = json['attachments'].first
            expect(attachment['title'].strip).to eq(title)
            expect(attachment['image_url'].strip).to eq(image_url)
          end
        end
        context 'by multiple players' do
          let(:image_url) do
            'http://chart.apis.google.com/chart?chco=000000,336699,339933,ff0000,cc99cc,cf5910&chf=bg,s,FFFFFF&chd=s:Siw9,AGAA&chdl=chris|tom&cht=ls&chs=750x400&chxr=0,24,82|1,0,8'
          end
          before do
            post '/api/slack', params: { token: '123', text: 'kart chart scoped to tom chris' }
          end

          specify do
            expect(response).to be_successful
            json = JSON.parse(response.body)
            expect(json['attachments'].count).to eq(1)
            attachment = json['attachments'].first
            expect(attachment['title'].strip).to eq(title)
            expect(attachment['image_url'].strip).to eq(image_url)
          end
        end
      end

      context 'by multiple filters' do
        let(:title) { 'Leaderboard: 4 matches from 8 days ago' }
        let(:image_url) do
          'http://chart.apis.google.com/chart?chco=000000,336699,339933,ff0000,cc99cc,cf5910&chf=bg,s,FFFFFF&chd=s:A9AA,AAA9&chdl=tom|mike&cht=ls&chs=750x400&chxr=0,0,8|1,0,8'
        end
        before do
          post '/api/slack', params: { token: '123', text: 'kart chart scoped to tom mike unknown since 8 days ago' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['attachments'].count).to eq(1)
          attachment = json['attachments'].first
          expect(attachment['title'].strip).to eq(title)
          expect(attachment['image_url'].strip).to eq(image_url)
        end
      end
    end

    describe 'mojo chart' do
      let(:image_url) do
        'https://chart.apis.google.com/chart?chxt=x,y&chco=ff0000&chf=bg,s,FFFFFF&chd=s:5678987678787899999878765432123210zzyxyxwvutstsrqpponmlklmlkjkjijihgffedcbaZaZYXWVUUTUTSRQRSRQPONONMLMLKKKKJKKLMLKKKKKLMNMLKKJIJKJIHIHGFEDCBAA&cht=lc&chs=750x400&chxr=0,0,142,10%7C1,-63,10'
      end

      context 'with a valid scope' do
        before do
          expect(Gchart).to receive(:line) { image_url }
          post '/api/slack', params: { token: '123', text: 'kart mojo scoped to tom chris since 1 week ago' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['attachments'].count).to eq(1)
          attachment = json['attachments'].first
          expect(attachment['title'].strip).to include('Mojo: 4 matches')
          expect(attachment['image_url'].strip).to eq(image_url)
        end
      end

      context 'with no players' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart mojo' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq <<~SLACK.strip
            ```
            You need to give me exactly two player names 🏄‍♀️
            ```
          SLACK
        end
      end

      context 'with one player' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart mojo scoped to tom' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq <<~SLACK.strip
            ```
            You need to give me exactly two player names 🏄‍♀️
            ```
          SLACK
        end
      end

      context 'with invalid player' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart mojo scoped to tom trev' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq <<~SLACK.strip
            ```
            trev doesn't exist 😿
            ```
          SLACK
        end
      end
    end

    describe 'large league league formats correctly' do
      before do
        post '/api/slack', params: { token: 'LargeLeague', text: 'kart leaderboard' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq <<~SLACK.strip
          ```
          # |      Name      |Score| ∆  |🎮
             -------- A League --------
           1|christian 🔥 (5)| 2876|+142| 6
           2|gt              | 2581| +57| 6
           3|chris (1)       | 2312|    | 1
           4|langers         | 2106| +26| 6
             -------- B League --------
           5|raj             | 1518|    | 1
           6|tom             | 1369| -22| 6
           7|mike            | 1341|    | 1
           8|jared           | 1164|    | 1
             -------- C League --------
           9|josh            |  982|    | 1
          10|wernah          |  579|    | 1
          11|andrew          |  334|    | 1
          12|carson          |   12|    | 1
             -------- D League --------
          13|samii           | -558|    | 1
          ```
        SLACK
      end
    end

    describe 'sort command' do
      context 'ascending (default)' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart leaderboard sort delta' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
            ```
            #|    Name    |Score|  ∆  |🎮
            4|raj         |  896|     | 3
            5|gt          |  799|  -55| 4
            2|tom         | 1369| +107| 4
            1|chris 🔥 (4)| 2473| +287| 4
            3|mike        | 1263|+1263| 1
            ```
          SLACK
        end
      end

      context 'descending' do
        before do
          post '/api/slack', params: { token: '123', text: 'kart leaderboard sort by games desc' }
        end

        specify do
          expect(response).to be_successful
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
            ```
            #|    Name    |Score|  ∆  |🎮
            5|gt          |  799|  -55| 4
            2|tom         | 1369| +107| 4
            1|chris 🔥 (4)| 2473| +287| 4
            4|raj         |  896|     | 3
            3|mike        | 1263|+1263| 1
            ```
          SLACK
        end
      end
    end

    describe 'streaks command' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart streaks' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
          ```
          +--------------------+
          |    Top Streaks     |
          +-----------+--------+
          | Player    | Streak |
          +-----------+--------+
          | chris     | 5      |
          | christian | 5      |
          +-----------+--------+
          ```
        SLACK
      end
    end

    describe 'perfect_matches command' do
      before do
        FactoryBot.create(:entered_match, player: Player.find_by(name: 'samii'), final_score: 90)

        post '/api/slack', params: { token: '123', text: 'kart perfect_matches' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
          ```
          +------------------+
          | Perfect Matches  |
          +--------+---------+
          | Player | Matches |
          +--------+---------+
          | samii  | 1       |
          +--------+---------+
          ```
        SLACK
      end
    end

    describe 'scoped perfect_matches command' do
      before do
        players = ['gt', 'samii', 'tom', 'raj'].map { |name| Player.find_by(name: name) }

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

        post '/api/slack', params: { token: '123', text: 'kart perfect_matches scoped to tom' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
          ```
          +-----------------------------------------+
          |         1 Perfect Match for tom         |
          +-----------------------------------------+
          | Tom (90), Raj (40), Samii (30), Gt (20) |
          +-----------------------------------------+
          ```
        SLACK
      end
    end

    describe 'defaulting to result command' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart mike tom' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          #|    Name    |Score| ∆  |🎮
           -------- A League --------
          1|chris 🔥 (4)| 2473|    | 4
          2|mike (1)    | 1605|+342| 2
          3|tom         | 1343| -25| 5
          4|raj         |  896|    | 3
           -------- B League --------
          5|gt          |  799|    | 4
          ```
        SLACK
      end
    end
    describe 'defaulting to result command with invalid player' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart mike trev' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          Unknown command mike
          ```
        SLACK
      end
    end

    describe 'gen_courses' do
      let!(:command) { double }
      before do
        expect(GenCoursesCommand).to receive(:new).and_return(command)
        expect(command).to receive(:execute).and_return(text: 'Command called', type: :raw)

        post '/api/slack', params: { token: '123', text: 'kart gen_courses' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
          Command called
        SLACK
      end
    end

    describe 'unknown command' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart foo' }
      end

      specify do
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          Unknown command foo
          ```
        SLACK
      end
    end
  end
end
