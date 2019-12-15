# frozen_string_literal: true

# Handles making moves for a player in a game.
class MoveMaker
  class << self
    # Attempts to place a word on the board.
    #
    # @param {Game} game - Game instance
    # @param {Array<Hash>} placements - [{ col: Int, row: Int, tile: Int }]
    # @return {Boolean} - True if successful, false otherwise
    def call(game:, placements:)
      @game = game
      placements = placements
      @current_player = @game.current_player

      placements.each do |placement|
        hand_tile = pick_tile_from_hand(placement[:tile])
        return false if hand_tile.blank? || illegal_placement?(placement)

        place_tile(placement: placement, tile: hand_tile)
      end

      # Attempt the transaction. We want to remove all `nil`s from the current
      # player's hand to account for the end game, when pulls from the tile bag
      # will be blank.
      @current_player.hand.compact!
      Game.transaction { @game.save! && @current_player.save! }
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    # Grabs a tile from the current player's hand and replaces it with a tile
    # from the tile bag.
    #
    # @param {Integer} tile_index - Index of tile to pick in hand
    # @return {String} - Tile that was picked
    def pick_tile_from_hand(tile_index)
      hand_tile = @current_player.hand[tile_index]
      @current_player.hand[tile_index] =
        @game.pull_random_tiles(count: 1, call_save: false).first
      hand_tile
    end

    # Determines whether a placement is legal.
    #
    # @param {Hash} placement - { col: Int, row: Int, tile: Int }
    # @return {Boolean} - True if illegal placement, false otherwise
    def illegal_placement?(placement)
      placement_out_of_bounds?(placement) || board_tile_present?(placement)
    end

    # Given a tile placement, returns true if it is not within the board.
    #
    # @param {Hash} placement - { col: Integer, row: Integer, tile: Integer }
    # @return {Boolean} - True if out of bounds, false otherwise
    def placement_out_of_bounds?(placement)
      col = @game.board[placement[:col]]
      col.nil? || col.length <= placement[:row]
    end

    # Given a tile placement, returns true if a tile is already present on the
    # board.
    #
    # @param {Hash} placement - { col: Integer, row: Integer, tile: Integer }
    # @return {Boolean} - True if board tile present, false otherwise
    def board_tile_present?(placement)
      @game.board[placement[:col]][placement[:row]].present?
    end

    # Places tile in board.
    #
    # @param {Hash} placement - { col: Integer, row: Integer, tile: Integer }
    # @param {String} tile - The tile to place
    # @return {void}
    def place_tile(placement:, tile:)
      @game.board[placement[:col]][placement[:row]] = tile
    end
  end
end
