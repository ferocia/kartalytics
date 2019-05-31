# frozen_string_literal: true

class Elo
  attr_reader :winner_rating, :loser_rating, :k_value

  def initialize(winner_rating, loser_rating, k_value = 16)
    @winner_rating = winner_rating.to_f
    @loser_rating = loser_rating.to_f
    @k_value = k_value.to_f
  end

  def rating_change_for_winner
    k_value * probability_of_winner_winning
  end

  def probability_of_winner_winning
    1 / (1 + 10**((winner_rating - loser_rating) / 400))
  end

  def new_winner_rating
    winner_rating + (k_value * probability_of_winner_winning)
  end

  def new_loser_rating
    loser_rating - (k_value * probability_of_winner_winning)
  end
end
