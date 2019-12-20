# frozen_string_literal: true

# Handles updating the scores of players in a game.
class ScoreCalculator
  class << self
    # Given a game, look through its current board state and calculate the
    # scores of each player.
    #
    # @param {Game} game - Game record
    # @return {void}
    def call(game); end
  end
end
