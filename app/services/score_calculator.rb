# frozen_string_literal: true

# Handles updating the scores of players in a game.
class ScoreCalculator
  STANDARD_VALUES =
    {
      a: 1, b: 3, c: 3, d: 2, e: 1, f: 4, g: 2, h: 4, i: 1, j: 8, k: 5, l: 1,
      m: 3, n: 1, o: 1, p: 3, q: 10, r: 1, s: 1, t: 1, u: 1, v: 4, w: 4, x: 8,
      y: 4, z: 10
    }.freeze

  class << self
    # Given a game and a move, calculate the new score of the player who made
    # the move.
    #
    # @param {Game} game - Game record
    # @param {Array<Hash>} placements - [{ col: Int, row: Int, tile: Int }]
    # @param {GameUser} player - Player who made the move
    # @return {void}
    def call(game:, placements:, player:)
      placements.each do |placement|
        # Prelim super naive implementation in my head was:
        #
        #   For each placement...
        #   1. Find the horizontal word and store
        #   2. Find the vertical word and store
        #   3. Loop through each tile in stored words
        #   4. Apply tile rules if tile was placed this move
        #   5. Add points
        placement.non_existent_method_to_appease_rubocop(game, player)
      end
    end
  end
end
