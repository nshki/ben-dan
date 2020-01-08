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
      @board = game.board
      @placements = placements
      @current_player = @game.current_player

      @placements.each do |placement|
        hand_tile = pick_tile_from_hand(placement[:tile])
        return false if hand_tile.blank? || illegal_placement?(placement)

        place_tile(placement: placement, tile: hand_tile)
      end

      return false unless straight_no_gaps? && opener_or_touching_tile?

      make_transaction
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    # Checks if the move is in a straight line without any gaps.
    #
    # @return {Boolean} - True if line without gaps, false otherwise
    def straight_no_gaps?
      cols = @placements.map { |placement| placement[:col] }.sort
      rows = @placements.map { |placement| placement[:row] }.sort
      vert_line = cols.uniq.count == 1
      horiz_line = rows.uniq.count == 1
      return false unless vert_line || horiz_line

      direction = vert_line ? :vert : :horiz
      gapless?(cols: cols, rows: rows, direction: direction)
    end

    # Checks for the absence of gaps.
    #
    # @param {Array<Integer>} cols - Column indices
    # @param {Array<Integer>} rows - Row indices
    # @param {Symbol} direction - :vert | :horiz
    # @return {Boolean} - True if gapless, false otherwise
    def gapless?(cols:, rows:, direction:)
      if direction == :vert
        (rows.first..rows.last).each do |row|
          return false if @board[cols.first][row].blank?
        end
      else
        (cols.first..cols.last).each do |col|
          return false if @board[col][rows.first].blank?
        end
      end

      true
    end

    # Determines whether the move is an opener or is touching a tile.
    #
    # @return {Boolean} - True or false
    def opener_or_touching_tile?
      opener? || (started? && touching_tile?)
    end

    # Determines whether the move is an opener or not.
    #
    # @return {Boolean} - True if opener, false otherwise
    def opener?
      @placements.each do |placement|
        col = placement[:col]
        row = placement[:row]
        return true if @board[col][row]['rule'] == 'start'
      end

      false
    end

    # Determines whether or not the starter tile has been filled.
    #
    # @return {Boolean} - True if filled, false otherwise
    def started?
      @board.each do |col|
        col.each do |tile|
          if tile.present? && tile['rule'] == 'start' && tile['tile'].present?
            return true
          end
        end
      end

      false
    end

    # Determines whether the move is touching an existing tile.
    #
    # @return {Boolean} - True if touching an existing tile, false otherwise
    def touching_tile?
      @placements.each do |placement|
        col = placement[:col]
        row = placement[:row]
        top = tile_present_at?(col: col, row: row - 1)
        left = tile_present_at?(col: col - 1, row: row)
        right = tile_present_at?(col: col + 1, row: row)
        bottom = tile_present_at?(col: col, row: row + 1)
        return true if top || bottom || left || right
      end

      false
    end

    # Determines whether there is a tile present at the given coordinates.
    #
    # @param {Integer} col - Column number
    # @param {Integer} row - Row number
    # @return {Boolean} - True if there is a tile present, false otherwise
    def tile_present_at?(col:, row:)
      return true if col.negative? || row.negative?

      return true if col >= @board.count || row >= @board.first.count

      tile = @board[col][row]
      tile.present? && tile['tile'].present?
    end

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
      col = @board[placement[:col]]
      col.nil? || col.length <= placement[:row]
    end

    # Given a tile placement, returns true if a tile is already present on the
    # board.
    #
    # @param {Hash} placement - { col: Integer, row: Integer }
    # @return {Boolean} - True if board tile present, false otherwise
    def board_tile_present?(placement)
      @board.dig(placement[:col], placement[:row], 'tile').present?
    end

    # Places tile in board.
    #
    # @param {Hash} placement - { col: Integer, row: Integer }
    # @param {String} tile - The tile to place
    # @return {void}
    def place_tile(placement:, tile:)
      col = placement[:col]
      row = placement[:row]
      @board[col][row] ||= { rule: nil }
      @board[col][row]['tile'] = tile
      @board[col][row]['player'] = @current_player.id
      @game.board = @board
    end

    # Attempt the transaction. We want to remove all `nil`s from the current
    # player's hand to account for the end game, when pulls from the tile bag
    # will be blank.
    #
    # @return {Boolean} - True on success, false otherwise
    def make_transaction
      @current_player.hand.compact!
      if (ok = Game.transaction { @game.save! && @current_player.save! })
        ScoreCalculator.call \
          game: @game,
          placements: @placements,
          player: @current_player
      end
      ok
    end
  end
end
