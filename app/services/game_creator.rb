# frozen_string_literal: true

# Service that handles starting new games between players.
class GameCreator
  # Instantiates new Game instance.
  #
  # @param {Integer} num_horiz_tiles - Number of horizontal tiles (cols)
  # @param {Integer} num_vert_tiles - NUmber of vertical tiles (rows)
  # @return {Game} - New Game instance
  def self.call(num_horiz_tiles: 2, num_vert_tiles: 2)
    board = Array.new(num_horiz_tiles) { Array.new(num_vert_tiles) }

    Game.create(board: board)
  end
end
