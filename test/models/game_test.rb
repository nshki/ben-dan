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

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'valid game' do
    game = FactoryBot.build(:game)

    assert(game.valid?)
  end

  test 'invalid unless board is a two-dimensional array with chars' do
    game_no_array = FactoryBot.build(:game, board: nil)
    game_not_array = FactoryBot.build(:game, board: 'not array')
    game_empty_array = FactoryBot.build(:game, board: [])
    game_bad_tile_format = FactoryBot.build(:game, board: [{ n: :o }])
    game_1d_array = FactoryBot.build \
      :game,
      board: [{ tile: 'a', rule: nil, player: nil }, nil, nil]
    game_2d_array = FactoryBot.build \
      :game,
      board: [[{ tile: 'a', rule: nil, player: nil }, nil]]
    game_3d_array = FactoryBot.build \
      :game,
      board: [[[{ tile: 'a', rule: nil, player: nil }, nil]]]

    assert_not(game_no_array.valid?)
    assert_not(game_not_array.valid?)
    assert_not(game_empty_array.valid?)
    assert_not(game_bad_tile_format.valid?)
    assert_not(game_1d_array.valid?)
    assert(game_2d_array.valid?)
    assert_not(game_3d_array.valid?)
  end

  test 'invalid unless tile bag only has single chars (or is empty)' do
    tile_bag_nils = FactoryBot.build(:game, tile_bag: [nil, nil])
    tile_bag_multichar = FactoryBot.build(:game, tile_bag: %w[aa bb])
    tile_bag_empty = FactoryBot.build(:game, tile_bag: [])
    tile_bag_letters = FactoryBot.build(:game, tile_bag: %w[a b])

    assert_not(tile_bag_nils.valid?)
    assert_not(tile_bag_multichar.valid?)
    assert(tile_bag_empty.valid?)
    assert(tile_bag_letters.valid?)
  end

  test 'can pull random tiles from tile bag' do
    game = FactoryBot.create(:game, tile_bag: %w[a b c])

    tiles = game.pull_random_tiles(count: 1)
    game.reload

    assert_equal(1, tiles.count)
    assert(tiles.first.in?(%w[a b c]))
    assert_equal(2, game.tile_bag.count)
    assert_not(game.tile_bag.include?(tiles.first))
  end
end
