# frozen_string_literal: true

# Service that handles starting new games between players.
class GameCreator
  # Instantiates new Game instance.
  #
  # @param {Integer} num_horiz_tiles - Number of horizontal tiles (cols)
  # @param {Integer} num_vert_tiles - Number of vertical tiles (rows)
  # @param {Array<User>} users - Players for this game
  # @return {Game} - New Game instance
  def self.call(num_horiz_tiles: 2, num_vert_tiles: 2, users: [])
    board = Array.new(num_horiz_tiles) { Array.new(num_vert_tiles) }
    current_turn_user = users.sample

    Game.create \
      board: board,
      users: users,
      current_turn_user: current_turn_user
  end
end
