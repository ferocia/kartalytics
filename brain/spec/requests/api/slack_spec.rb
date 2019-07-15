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
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          +------+-------+-------+--------+-------+--------+--------+
          |           Leaderboard since about 1 month ago           |
          +------+-------+-------+--------+-------+--------+--------+
          | Rank | Name  | Score | Change | Place | Streak | Played |
          +------+-------+-------+--------+-------+--------+--------+
          | 1    | jared | 1393  | +227   | 1     | 3      | 3      |
          | 2    | josh  | -57   | +23    | 2     |        | 3      |
          +------+-------+-------+--------+-------+--------+--------+
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
        expect(response).to be_success
        json = JSON.parse(response.body)

        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          +------+----------+-------+--------+-------+--------+--------+
          |            Leaderboard since about 1 month ago             |
          +------+----------+-------+--------+-------+--------+--------+
          | Rank | Name     | Score | Change | Place | Streak | Played |
          +------+----------+-------+--------+-------+--------+--------+
          | 1    | chris 🔥 | 2473  | +287   | 1     | 4      | 4      |
          | 2    | tom      | 1369  | +107   | 3     |        | 4      |
          | 3    | mike     | 1263  | +1263  | 2     |        | 1      |
          | 4    | raj      | 896   |        |       |        | 3      |
          | 5    | gt       | 799   | -55    | 4     |        | 4      |
          +------+----------+-------+--------+-------+--------+--------+
          ```
        SLACK
      end
    end

    describe 'leaderboard (elo)' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart leaderboard_elo' }
      end
      specify do
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          +------+----------+-------+--------+--------+--------+---------+--------+
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
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          +------+----------+-------+--------+-------+--------+--------+
          |            Leaderboard since about 1 month ago             |
          +------+----------+-------+--------+-------+--------+--------+
          | Rank | Name     | Score | Change | Place | Streak | Played |
          +------+----------+-------+--------+-------+--------+--------+
          | 1    | chris 🔥 | 2473  | +287   | 1     | 4      | 4      |
          | 2    | tom      | 1369  | +107   | 3     |        | 4      |
          | 3    | mike     | 1263  | +1263  | 2     |        | 1      |
          | 4    | raj      | 896   |        |       |        | 3      |
          | 5    | gt       | 799   | -55    | 4     |        | 4      |
          +------+----------+-------+--------+-------+--------+--------+
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
          expect(response).to be_success
          expect(Match.count).to eq(@original_count - 1)

          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            +------+-------+-------+--------+-------+--------+--------+
            |           Leaderboard since over 3 years ago            |
            +------+-------+-------+--------+-------+--------+--------+
            | Rank | Name  | Score | Change | Place | Streak | Played |
            +------+-------+-------+--------+-------+--------+--------+
            | 1    | chris | 2187  | +231   | 1     | 3      | 3      |
            | 2    | tom   | 1262  | +38    | 3     |        | 3      |
            | 3    | raj   | 896   | +1111  | 2     |        | 3      |
            | 4    | gt    | 853   | -176   | 4     |        | 3      |
            +------+-------+-------+--------+-------+--------+--------+
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
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            +----------+------+--------+------+
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
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json['text'].strip).to eq(<<~SLACK.strip)
                      ```
            +----------+------+--------+------+
            |           jared vs...           |
            +----------+------+--------+------+
            | Opponent | Wins | Losses | Mojo |
            +----------+------+--------+------+
            +----------+------+--------+------+
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
            expect(response).to be_success
            json = JSON.parse(response.body)
            expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              You gotta give me a player name, bro!
              ```
            SLACK
          end
        end

        context 'with no player found' do
          before do
            post '/api/slack', params: { token: '123', text: 'kart inspect bilbo' }
          end
          specify do
            expect(response).to be_success
            json = JSON.parse(response.body)
            expect(json['text'].strip).to eq(<<~SLACK.strip)
                          ```
              bilbo ain't a player, bro!
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
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          +------+----------+-------+--------+-------+--------+--------+
          |            Leaderboard since about 1 month ago             |
          +------+----------+-------+--------+-------+--------+--------+
          | Rank | Name     | Score | Change | Place | Streak | Played |
          +------+----------+-------+--------+-------+--------+--------+
          | 1    | chris 🔥 | 2473  |        |       | 4      | 4      |
          | 2    | mike     | 1605  | +342   | 1     | 1      | 2      |
          | 3    | tom      | 1343  | -25    | 2     |        | 5      |
          | 4    | raj      | 896   |        |       |        | 3      |
          | 5    | gt       | 799   |        |       |        | 4      |
          +------+----------+-------+--------+-------+--------+--------+
          ```
        SLACK
      end
    end
    describe 'result with invalid player' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart result mike trev' }
      end

      specify do
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          Unknown player: 'trev'

          Known players
          -------------
          chris
          gt
          jared
          josh
          langers
          mike
          raj
          tom
          ```
        SLACK
      end
    end

    describe 'result with duplicate player' do
      before do
        post '/api/slack', params: { token: '123', text: 'kart result mike mike' }
      end

      specify do
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['text'].strip).to eq(<<~SLACK.strip)
                  ```
          No duplicates please, bro D:
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
          expect(response).to be_success
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
          expect(response).to be_success
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
            expect(response).to be_success
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
            expect(response).to be_success
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
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json['attachments'].count).to eq(1)
          attachment = json['attachments'].first
          expect(attachment['title'].strip).to eq(title)
          expect(attachment['image_url'].strip).to eq(image_url)
        end
      end
    end
  end
end
