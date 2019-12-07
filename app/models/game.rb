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
  TILES = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z].freeze

  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users
  belongs_to :current_turn_user, class_name: 'User', optional: true

  validate :validate_board_structure
  validate :validate_tile_bag

  # Gets tiles from the tile bag.
  #
  # @param {Integer} count - How many tiles to pull
  # @return {Array<String>} - Tiles from the tile bag
  def pull_random_tiles(count:)
    tiles = []

    count.times do
      random_tile = tile_bag.delete_at(rand(tile_bag.count))
      tiles.push(random_tile)
    end

    save
    tiles
  end

  private

  # Validates that the board is:
  #   - at most a two-dimensional array
  #   - contains only chars or nils
  #
  # @return {void}
  def validate_board_structure
    errors.add(:board, 'must be an array') && return unless board.is_a?(Array)

    board.each do |col|
      if col.is_a?(Array)
        col.each { |row| validate_board_piece(row) }
      else
        validate_board_piece(col)
      end
    end
  end

  # Validates that the given object is a char or nil.
  #
  # @return {void}
  def validate_board_piece(piece)
    return if (piece.is_a?(String) && piece.length == 1) || piece.nil?

    errors.add(:board, 'can only contain characters or blanks')
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
end
