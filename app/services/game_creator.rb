# frozen_string_literal: true

# Service that handles starting new games between players.
class GameCreator
  START_COORDS = [[7, 7]].freeze
  DL_COORDS =
    [
      [1, 2], [1, 12], [2, 1], [2, 4], [2, 10], [2, 13],
      [4, 2], [4, 6], [4, 8], [4, 12], [6, 4], [6, 10],
      [8, 4], [8, 10], [10, 2], [10, 6], [10, 8], [10, 12],
      [12, 1], [12, 4], [12, 10], [12, 13], [13, 2], [13, 12]
    ].freeze
  TL_COORDS =
    [
      [0, 6], [0, 8], [3, 3], [3, 11], [5, 5], [5, 9], [6, 0], [6, 14],
      [8, 0], [8, 14], [9, 5], [9, 9], [11, 3], [11, 11], [14, 6], [14, 8]
    ].freeze
  DW_COORDS =
    [
      [1, 5], [1, 9], [3, 7], [5, 1], [5, 13], [7, 3], [7, 11],
      [9, 1], [9, 13], [11, 9], [11, 7], [13, 5], [13, 9]
    ].freeze
  TW_COORDS =
    [
      [0, 3], [0, 11], [3, 0], [3, 14], [11, 0], [11, 14], [14, 3], [14, 11]
    ].freeze

  class << self
    # Instantiates new Game instance.
    #
    # @param {Array<User>} users - Players for this game
    # @return {Game} - New Game instance
    def call(users: [])
      @board = Array.new(15) { Array.new(15) }
      populate_tiles
      @game = Game.create \
        board: @board,
        users: users,
        current_turn_user: users.sample,
        tile_bag: generate_tile_bag(tile_count: 100)
      deal_hands(tile_count: 8)

      @game
    end

    private

    # Fill in tiles into the newly generated board.
    #
    # @return {void}
    def populate_tiles
      fill = proc do |coords, rule|
        coords.each do |col, row|
          @board[col][row] = { tile: nil, player: nil, rule: rule }
        end
      end

      fill.call(DL_COORDS, :dl)
      fill.call(TL_COORDS, :tl)
      fill.call(DW_COORDS, :dw)
      fill.call(TW_COORDS, :tw)
      fill.call(START_COORDS, :start)
    end

    # Given a tile count, generates a randomized array of tiles.
    #
    # @param {Integer} tile_count - Number of tiles to put in bag
    # @return {Array<String>} - Randomized array of tiles
    def generate_tile_bag(tile_count:)
      tile_bag = []
      tile_count.times { tile_bag.push(Game::TILES.sample) }
      tile_bag
    end

    # Deal hands to each player.
    #
    # @param {Integer} tile_count - Number of tiles to deal to each player
    # @return {void}
    def deal_hands(tile_count:)
      @game.users.each do |user|
        player = @game.player(user)
        player.update(hand: @game.pull_random_tiles(count: tile_count))
      end
    end
  end
end
