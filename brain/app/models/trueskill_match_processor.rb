# frozen_string_literal: true

require 'saulabs/trueskill'

class TrueskillMatchProcessor
  include Saulabs::TrueSkill
  # http://en.wikipedia.org/wiki/TrueSkill
  # http://research.microsoft.com/pubs/184298/sbsl_ecml2012.pdf

  # TODO: Add effect to activity to reduce scores when you haven't played
  #       in a long time, the optional 'activity' field in Rating adds weighting
  #       defaults to 1.0.
  def self.process(match, players_map)
    players = match.players_in_order.split(',').map do |player|
      players_map[player]
    end.compact

    original_team_ratings = []
    team_ratings = players.collect do |player|
      original_team_ratings << player.skill_rating.dup
      [player.skill_rating]
    end

    # [team_1,team_2,team_3], [1,2,3,4] #team array + positions
    graph = FactorGraph.new(team_ratings, (1...players.count).to_a)
    graph.update_skills

    dummy_player = Player.new

    players.each_with_index do |player, player_pos|
      dummy_player.skill_rating = original_team_ratings[player_pos]
      new_score      = players[player_pos].calculated_score
      score_change   = new_score - dummy_player.calculated_score

      last_match_position = player_pos + 1
      player.score                   = new_score
      player.score_change_last_match = score_change
      player.position_last_match     = last_match_position

      player.matches_played += 1
      player.streak = player_pos == 0 ? player.streak + 1 : 0
    end
  end
end
