# frozen_string_literal: true

# Service that handles starting new games between players.
class GameCreator
  # Instantiates new Game instance.
  #
  # @param {Integer} num_horiz_tiles - Number of horizontal tiles (cols)
  # @param {Integer} num_vert_tiles - Number of vertical tiles (rows)
  # @param {Array<User>} users - Players for this game
  # @return {Game} - New Game instance
  def self.call(num_horiz_tiles: 15, num_vert_tiles: 15, users: [])
    board = generate_board \
      num_horiz_tiles: num_horiz_tiles,
      num_vert_tiles: num_vert_tiles
    game = Game.create \
      board: board,
      users: users,
      current_turn_user: users.sample,
      tile_bag: generate_tile_bag(tile_count: 100)
    deal_tiles(game: game, tile_count: 8)

    game
  end

  # Given dimensions, generates a new two-dimensional array.
  #
  # @param {Integer} num_horiz_tiles - Number of horizontal tiles (cols)
  # @param {Integer} num_vert_tiles - Number of vertical tiles (rows)
  # @return {Array<Array>} - Two-dimensional array
  def self.generate_board(num_horiz_tiles:, num_vert_tiles:)
    Array.new(num_horiz_tiles) { Array.new(num_vert_tiles) }
  end

  # Given a tile count, generates a randomized array of tiles.
  #
  # @param {Integer} tile_count - Number of tiles to put in bag
  # @return {Array<String>} - Randomized array of tiles
  def self.generate_tile_bag(tile_count:)
    tile_bag = []
    tile_count.times { tile_bag.push(Game::TILES.sample) }
    tile_bag
  end

  # Given a Game, deal hands to each player.
  #
  # @param {Game} game - A game
  # @param {Integer} tile_count - Number of tiles to deal to each player
  # @return {void}
  def self.deal_tiles(game:, tile_count:)
    game.users.each do |user|
      game_user = game.game_users.find_by(user: user)
      game_user.update(hand: game.pull_random_tiles(count: tile_count))
    end
  end
end
