# frozen_string_literal: true

require 'test_helper'

class MoveMakerTest < ActiveSupport::TestCase
  test 'returns true for a legal move and updates records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    game_user1 = game.game_users.find_by(user: user1)
    game_user1.update(hand: %w[a a])
    FactoryBot.create(:word, spelling: 'aa')

    result = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 0, row: 1, tile: 1 }]
    game.reload
    game_user1.reload

    assert(result)
    assert_equal(['b'], game.tile_bag)            # Tiles get removed from bag
    assert_equal(%w[b b], game_user1.hand)        # Hand gets updated
    assert_equal('a', game.board[0][0])           # New tile on board
    assert_equal('a', game.board[0][1])           # New tile on board
    assert_equal(user2, game.current_turn_user)   # Passes turn
  end

  test 'returns false for out of bounds moves and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [['d', nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    game_user1 = game.game_users.find_by(user: user1)
    game_user1.update(hand: %w[a a c c])

    result_out_of_bounds = MoveMaker.call \
      game: game,
      placements: [{ col: 2, row: 2, tile: 0 }]
    game.reload
    game_user1.reload

    assert_not(result_out_of_bounds)
    assert_equal([['d', nil], [nil, nil]], game.board)
    assert_equal(%w[a a c c], game_user1.hand)
    assert_equal(user1, game.current_turn_user)
  end

  test 'returns false for invalid words and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [['d', nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    game_user1 = game.game_users.find_by(user: user1)
    game_user1.update(hand: %w[a a c c])

    result_invalid_word = MoveMaker.call \
      game: game.reload,
      placements: [{ col: 1, row: 0, tile: 2 }]
    game.reload
    game_user1.reload

    assert_not(result_invalid_word)
    assert_equal([['d', nil], [nil, nil]], game.board)
    assert_equal(%w[a a c c], game_user1.hand)
    assert_equal(user1, game.current_turn_user)
  end

  test 'returns false for present board tiles and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [['d', nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    game_user1 = game.game_users.find_by(user: user1)
    game_user1.update(hand: %w[a a c c])

    result_tile_present = MoveMaker.call \
      game: game.reload,
      placements: [{ col: 0, row: 0, tile: 0 }]
    game.reload
    game_user1.reload

    assert_not(result_tile_present)
    assert_equal([['d', nil], [nil, nil]], game.board)
    assert_equal(%w[a a c c], game_user1.hand)
    assert_equal(user1, game.current_turn_user)
  end

  test 'returns false for non-existent hand tile and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [['d', nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    game_user1 = game.game_users.find_by(user: user1)
    game_user1.update(hand: %w[a a c c])

    result_non_existent_hand_tile = MoveMaker.call \
      game: game.reload,
      placements: [{ col: 0, row: 0, tile: 4 }]
    game.reload
    game_user1.reload

    assert_not(result_non_existent_hand_tile)
    assert_equal([['d', nil], [nil, nil]], game.board)
    assert_equal(%w[a a c c], game_user1.hand)
    assert_equal(user1, game.current_turn_user)
  end
end
