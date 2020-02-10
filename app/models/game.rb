# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id                   :bigint           not null, primary key
#  board                :jsonb
#  tile_bag             :string           default([]), is an Array
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  current_turn_user_id :bigint
#

# Represents a single game.
class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users
  belongs_to :current_turn_user, class_name: 'User', optional: true

  validate :validate_board_structure
  validate :validate_board_words
  validate :validate_tile_bag
  validate :validate_single_char_opener

  before_update :pass_turn, if: :board_changed?

  # Gets tiles from the tile bag.
  #
  # @param {Integer} count - How many tiles to pull
  # @param {Boolean} call_save - Determines whether a transaction should occur
  # @return {Array<String>} - Tiles from the tile bag
  def pull_random_tiles(count:, call_save: true)
    tiles = []

    count.times do
      random_tile = tile_bag.delete_at(rand(tile_bag.count))
      tiles.push(random_tile)
    end

    save if call_save
    tiles
  end

  # Returns the corresponding GameUser to the active User.
  #
  # @return {GameUser} - Player who is up next
  def current_player
    game_users.find_by(user: current_turn_user)
  end

  # Given a user, returns the corresponding GameUser.
  #
  # @param {User} user - User record
  # @return {GameUser} - Player for the User
  def player(user)
    game_users.find_by(user: user)
  end

  # Given a user, returns the username of their opponent.
  #
  # @param {User} user - User record
  # @return {String} - Name of opponent
  def opponent_of(user)
    users.where.not(id: user.id).first.username
  end

  # Passes the turn to the next player.
  #
  # @param {Boolean} call_save - Commit to database or not
  # @return {void}
  def pass_turn(call_save: false)
    next_user_index = users.index(current_turn_user) + 1
    next_user_index = 0 if next_user_index >= users.length
    self.current_turn_user = users[next_user_index]
    save if call_save
  end

  # Determines whether the game is done.
  #
  # @return {Boolean} - True if finished, false otherwise
  def finished?
    hands = game_users.pluck(:hand)
    an_empty_hand = hands.select(&:empty?)
    tile_bag.empty? && an_empty_hand.present?
  end

  private

  # Validates that the board is a two-dimensional array.
  #
  # @return {void}
  def validate_board_structure
    validation_message = 'must be 2d array'

    unless board.is_a?(Array) && board.length.positive?
      errors.add(:board, validation_message) && return
    end

    board.each do |col|
      errors.add(:board, validation_message) && break unless col.is_a?(Array)

      col.each { |row| validate_board_piece(row) }
    end
  end

  # Validates that the given object is a formatted `Hash` or nil.
  #
  # @param {Object} piece - Some object
  # @return {void}
  def validate_board_piece(piece)
    valid_hash =
      piece.is_a?(Hash) &&
      piece.symbolize_keys.key?(:tile) &&
      piece.symbolize_keys.key?(:rule) &&
      piece.symbolize_keys.key?(:player)
    return if valid_hash || piece.nil?

    errors.add(:board, 'must have correctly formatted pieces')
  end

  # Validates that the tile bag is:
  #   - filled with only single chars
  #
  # @return {void}
  def validate_tile_bag
    tile_bag.each do |tile|
      unless tile&.length == 1
        errors.add(:tile_bag, 'can only contain single characters') && break
      end
    end
  end

  # Validates that the board contains only valid words.
  #
  # @return {void}
  def validate_board_words
    col_words, row_words = gather_all_words
    validate_words(col_words)
    validate_words(row_words)
  rescue StandardError
    # Accounting for when the board is not a proper 2D array. The board
    # structure validation will handle that case.
    false
  end

  # Gather all words in the board, organized by columns and rows.
  #
  # @return {Array<Array<String>>} - [<all column words>, <all row words>]
  def gather_all_words
    col_words = Array.new(board.count, '')
    row_words = Array.new(board.first.count, '')

    board.each_with_index do |col, y|
      col.each_with_index do |tile, x|
        str = tile.try(:[], 'tile') || ' '
        col_words[y] += str
        row_words[x] += str
      end
    end

    [col_words, row_words]
  end

  # Validates a single character opening move.
  #
  # @return {void}
  def validate_single_char_opener
    tiles = placed_tiles
    unless tiles.present? && tiles.count == 1 && tiles.first['rule'] == 'start'
      return
    end

    word = tiles.first['tile']
    return if Word.find_by(spelling: word).present?

    errors.add(:base, I18n.t('game.invalid_word'))
  rescue StandardError
    # This is in case the board isn't a 2D array, causing "not array" errors.
    nil
  end

  # Returns all placed tiles on the board.
  #
  # @return {Array<Hash>} - Array of tile hashes
  def placed_tiles
    board&.flatten&.compact&.select { |tile| tile['tile'].present? }
  end

  # Validates each word in the given string.
  #
  # @param {Array<String>} all_axis_tiles - An axis as strings
  # @return {void}
  def validate_words(all_axis_tiles)
    all_axis_tiles.each do |words|
      words.split(' ').each do |word|
        validate_word(word)
      end
    end
  end

  # Validates the given word.
  #
  # @param {String} word - Word to validate
  # @return {void}
  def validate_word(word)
    return if word.blank? || word.length <= 1

    return if Word.find_by(spelling: word).present?

    errors.add(:base, I18n.t('game.invalid_word'))
  end
end
