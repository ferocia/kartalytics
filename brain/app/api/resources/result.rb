# frozen_string_literal: true

require 'slack'
module Resources
  class Result < Grape::API
    format :json

    params do
      requires :league_id, type: String
      requires :match_result, type: String
    end
    post do
      begin
        match_result = params[:match_result].to_s.downcase.split
        SubmitMatchCommand.new(params[:league_id], match_result).execute
        ::Slack.notify(TrueskillLeaderboardCommand.new(params[:league_id]).execute)
        present TrueskillLeaderboard.new(params[:league_id], 1.month.ago).latest,
                with: Entities::TrueskillPlayer
      rescue Match::UnknownPlayerError => e
        status 404
        { error: "Unknown player: '#{e}'" }
      rescue Match::DuplicatePlayerError
        status 400
        { error: 'No duplicates' }
      rescue Match::NotEnoughPlayersError
        status 400
        { error: 'You need at least two players' }
      end
    end

    desc 'Undo last result'
    params do
      requires :league_id, type: String
    end
    delete 'undo_latest' do
      last_match = Match.where(league_id: params[:league_id]).last
      if last_match
        if last_match.destroy
          leaderboard_body = TrueskillLeaderboardCommand.new(params[:league_id]).execute
          body = "Last match (result: #{last_match.players_in_order}) has been removed!\n#{leaderboard_body}"
          ::Slack.notify(body)

          status 200
          { result: 'ok', match: last_match.players_in_order }
        else
          status 400
          { error: last_match.errors.full_messages.join(', ') }
        end
      else
        status 404
        { error: 'No matches to undo' }
      end
    end
  end
end
