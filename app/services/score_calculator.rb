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
    # For each placement...
    #   1. Find the horizontal word and store
    #   2. Find the vertical word and store
    #   3. Loop through each tile in stored words
    #   4. Apply tile rules if tile was placed this move
    #   5. Add points
    #
    # @param {Game} game - Game record
    # @param {Array<Hash>} placements - [{ col: Int, row: Int }]
    # @param {GameUser} player - Player who made the move
    # @return {void}
    def call(game:, placements:, player:)
      @game = game
      @board = @game.board
      @placements = placements
      @player = player
      apply_points(new_words)
    end

    private

    # Apply points for given words.
    #
    # @param {Array<Array<Hash>>} words -
    #   [[{ tile: String, rule: Symbol, row: Int, col: Int }]]
    # @return {void}
    def apply_points(words)
      new_points = 0

      words.each do |word|
        word.each do |tile|
          tile.symbolize_keys!
          new_points += apply_tile_rules(tile)
        end
      end

      new_points = apply_word_rules(words: words, points: new_points)

      @player.score += new_points
      @player.save
    end

    # Given a tile, apply tile rules, if any.
    #
    # @param {Hash} tile - { rule: String }
    # @return {Integer} - Points that the given tile counts for
    def apply_tile_rules(tile)
      points = STANDARD_VALUES[tile[:tile].to_sym]

      if part_of_move?(tile)
        points *= 2 if tile[:rule] == 'dl'
        points *= 3 if tile[:rule] == 'tl'
      end

      points
    end

    # Given words and points, apply any applicable word point rules.
    #
    # @param {Array<Array<Hash>>} words -
    #   [[{ tile: String, rule: String, row: Int, col: Int }]]
    # @return {Integer} - Newly manipulated
    def apply_word_rules(words:, points:)
      processed_tiles = []

      words.each do |word|
        word.each do |tile|
          tile.symbolize_keys!
          next if processed_tiles.include?(tile) || !part_of_move?(tile)

          points *= 2 if tile[:rule] == 'dw'
          points *= 3 if tile[:rule] == 'tw'
          processed_tiles.push(tile)
        end
      end

      points
    end

    # Determines whether a given tile was a part of the move.
    #
    # @param {Hash} tile - { col: Int, row: Int }
    # @return {Boolean} - True if tile is part of the move, false otherwise
    def part_of_move?(tile)
      tile.symbolize_keys!

      @placements.each do |placement|
        col_matches = placement[:col] == tile[:col]
        row_matches = placement[:row] == tile[:row]
        return true if col_matches && row_matches
      end

      false
    end

    # Find new words formed by the move.
    #
    # @return {Array<Array<Hash>>} - [[{ <tile hash> }]]
    def new_words
      words = []

      @placements.each do |placement|
        horiz_word = horiz_tiles(placement)
        vert_word = vert_tiles(placement)
        words.push(horiz_word) unless words.include?(horiz_word)
        words.push(vert_word) unless words.include?(vert_word)
      end

      words.push(single_letter_opener)
      words.compact
    end

    # Find the horizontal word associated with the placement, if any.
    #
    # @param {Hash} placement - { col: Int, row: Int }
    # @return {Array<Hash>} -
    #   [{ tile: String, rule: Symbol, row: Int, col: Int }]
    def horiz_tiles(placement)
      tiles = []
      curr_row = placement[:row]
      curr_col = shimmy_col(col: placement[:col], row: curr_row)

      # Add tiles to the list.
      while (curr_tile = @board.dig(curr_col, curr_row)) &&
            curr_tile.try(:[], 'tile').present?
        tiles.push(curr_tile.merge(col: curr_col, row: curr_row))
        curr_col += 1
      end

      tiles.count > 1 ? tiles : nil
    end

    # Find the vertical word associated with the placement, if any.
    #
    # @param {Hash} placement - { col: Int, row: Int }
    # @return {Array<Hash>} -
    #   [{ tile: String, rule: String, row: Int, col: Int }]
    def vert_tiles(placement)
      tiles = []
      curr_col = placement[:col]
      curr_row = shimmy_row(col: curr_col, row: placement[:row])

      # Add tiles to the list.
      while (curr_tile = @board.dig(curr_col, curr_row)) &&
            curr_tile.try(:[], 'tile').present?
        tiles.push(curr_tile.merge(col: curr_col, row: curr_row))
        curr_row += 1
      end

      tiles.count > 1 ? tiles : nil
    end

    # Returns a single tile if the move was consisted of just a single letter.
    #
    # @return {Array<Hash>} -
    #   [{ tile: String, rule: String, col: Integer, row: Integer }]
    def single_letter_opener
      return unless @placements.count == 1

      placement = @placements.first
      col = placement[:col]
      row = placement[:row]
      tile = @board.dig(placement[:col], placement[:row])
      return unless tile['rule'] == 'start'

      [tile.merge(col: col, row: row)]
    end

    # Shimmy down to the furthest non-blank, horizontal tile.
    #
    # @param {Integer} col - Column index
    # @param {Integer} row - Row index
    # @return {Integer} - Column index
    def shimmy_col(col:, row:)
      while col.positive? &&
            @board.dig(col - 1, row).present? &&
            @board[col - 1][row]['tile'].present?
        col -= 1
      end

      col
    end

    # Shimmy down to the furthest non-blank, vertical tile.
    #
    # @param {Integer} col - Column index
    # @param {Integer} row - Row index
    # @return {Integer} - Row index
    def shimmy_row(col:, row:)
      while row.positive? &&
            @board.dig(col, row - 1).present? &&
            @board[col][row - 1]['tile'].present?
        row -= 1
      end
      row
    end
  end
end
