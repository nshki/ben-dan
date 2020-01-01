# frozen_string_literal: true

require 'test_helper'

class MoveMakerTest < ActiveSupport::TestCase
  test 'returns true for a legal move and updates records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [[{ tile: nil, rule: 'u', player: nil }, nil]],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player2 = game.player(user2)
    player1.update(hand: %w[a a])
    FactoryBot.create(:word, spelling: 'aa')

    result = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 0, row: 1, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert(result)
    assert_equal(['b'], game.tile_bag)              # Tiles get removed from bag
    assert_equal(%w[b b], player1.hand)             # Hand gets updated
    assert_equal('a', board[0][0]['tile'])          # New tile gets placed
    assert_equal('u', board[0][0]['rule'])          # Rule is unchanged
    assert_equal(player1.id, board[0][0]['player']) # Correct player
    assert_equal('a', board[0][1]['tile'])          # New tile gets placed
    assert_nil(board[0][1]['rule'])                 # Rule is nil
    assert_equal(player1.id, board[0][1]['player']) # Correct player
    assert_equal(player2, game.current_player)      # Passes turn
  end

  test 'returns false for out of bounds moves and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [[{ tile: 'd', rule: nil, player: nil }, nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a c c])

    result_out_of_bounds = MoveMaker.call \
      game: game,
      placements: [{ col: 2, row: 2, tile: 0 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_out_of_bounds)
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'returns false for invalid words and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [[{ tile: 'd', rule: nil, player: nil }, nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a c c])

    result_invalid_word = MoveMaker.call \
      game: game.reload,
      placements: [{ col: 1, row: 0, tile: 2 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_invalid_word)
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'returns false for present board tiles and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [[{ tile: 'd', rule: nil, player: nil }, nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a c c])

    result_tile_present = MoveMaker.call \
      game: game.reload,
      placements: [{ col: 0, row: 0, tile: 0 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_tile_present)
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'returns false for non-existent hand tile and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [[{ tile: 'd', rule: nil, player: nil }, nil], [nil, nil]],
      tile_bag: %w[b b b],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a c c])

    result_non_existent_hand_tile = MoveMaker.call \
      game: game.reload,
      placements: [{ col: 0, row: 0, tile: 4 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_non_existent_hand_tile)
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end
end
