# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id                   :bigint           not null, primary key
#  board                :jsonb
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

  test 'invalid unless board is at most a two-dimensional array with chars' do
    game_no_array = FactoryBot.build(:game, board: nil)
    game_not_array = FactoryBot.build(:game, board: 'not array')
    game_array_with_non_chars = FactoryBot.build(:game, board: [1, 'abc'])
    game_empty_array = FactoryBot.build(:game, board: [])
    game_1d_array = FactoryBot.build(:game, board: ['a', nil, nil])
    game_2d_array = FactoryBot.build(:game, board: [['a', nil]])
    game_3d_array = FactoryBot.build(:game, board: [[['a', nil]]])

    assert_not(game_no_array.valid?)
    assert_not(game_not_array.valid?)
    assert_not(game_array_with_non_chars.valid?)
    assert(game_empty_array.valid?)
    assert(game_1d_array.valid?)
    assert(game_2d_array.valid?)
    assert_not(game_3d_array.valid?)
  end
end
