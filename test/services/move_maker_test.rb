# frozen_string_literal: true

require 'test_helper'

class MoveMakerTest < ActiveSupport::TestCase
  test 'returns true for a legal move and updates records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'aa')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [
        [nil, nil],
        [{ tile: 'a', rule: :start, player: nil }, nil]
      ],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player2 = game.player(user2)
    player1.update(hand: %w[a a])

    result = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 0, row: 1, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert(result)
    assert_equal(['b'], game.tile_bag)              # Tiles get removed from bag
    assert_equal(%w[b b], player1.hand)             # Hand gets updated
    assert_equal('a', board[0][0]['tile'])          # 1st tile gets placed
    assert_equal(player1.id, board[0][0]['player']) # 1st tile from player
    assert_equal('a', board[0][1]['tile'])          # 2nd tile gets placed
    assert_equal(player1.id, board[0][1]['player']) # 2nd tile from player
    assert_equal('a', board[1][0]['tile'])          # Old tile is unchanged
    assert_equal('start', board[1][0]['rule'])      # Old rule is unchanged
    assert_nil(board[1][0]['player'])               # Old player is unchanged
    assert_equal(player2, game.current_player)      # Passes turn
  end

  test 'adds errors for moves that have gaps and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [[{ tile: nil, rule: :start, player: nil }, nil, nil]],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a])
    FactoryBot.create(:word, spelling: 'aa')

    result_with_gap = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 0, row: 2, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_with_gap)
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.must_be_gapless'))
    assert_nil(board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_equal(%w[a a], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'adds errors for non-straight moves and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [[{ tile: nil, rule: :start, player: nil }, nil], [nil, nil]],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a])
    FactoryBot.create(:word, spelling: 'aa')

    result_not_straight = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 1, row: 1, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_not_straight)
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.must_be_straight'))
    assert_nil(board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'adds errors for disconnected moves and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [[{ tile: nil, rule: :start, player: nil }, nil], [nil, nil]],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a])
    FactoryBot.create(:word, spelling: 'aa')

    result_disconnected = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 1, row: 1, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_disconnected)
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.must_be_straight'))
    assert_nil(board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'adds errors if start tile not filled and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [[nil, nil], [nil, { tile: nil, rule: :start, player: nil }]],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a])
    FactoryBot.create(:word, spelling: 'aa')

    result_illegal_opener = MoveMaker.call \
      game: game,
      placements: [{ col: 0, row: 0, tile: 0 }, { col: 0, row: 1, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert_not(result_illegal_opener)
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.illegal_opener'))
    assert_nil(board[0][0])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1]['tile'])
    assert_equal(%w[a a], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'returns true for legal opening moves and updates records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = FactoryBot.create \
      :game,
      tile_bag: %w[b b b],
      board: [[nil, nil], [nil, { tile: nil, rule: :start, player: nil }]],
      users: [user1, user2],
      current_turn_user: user1
    player1 = game.player(user1)
    player1.update(hand: %w[a a])
    player2 = game.player(user2)
    FactoryBot.create(:word, spelling: 'aa')

    result_legal_opener = MoveMaker.call \
      game: game,
      placements: [{ col: 1, row: 0, tile: 0 }, { col: 1, row: 1, tile: 1 }]
    game.reload
    player1.reload
    board = game.board

    assert(result_legal_opener)
    assert_nil(board[0][0])
    assert_nil(board[0][1])
    assert_equal('a', board[1][0]['tile'])
    assert_equal('a', board[1][1]['tile'])
    assert_equal(%w[b b], player1.hand)
    assert_equal(player2, game.current_player)
  end

  test 'adds errors for out of bounds moves and does not update records' do
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
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.must_be_in_bounds'))
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'adds errors for invalid words and does not update records' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'a')
    FactoryBot.create(:word, spelling: 'd')
    game = FactoryBot.create \
      :game,
      board: [
        [{ tile: 'd', rule: nil, player: nil }, nil],
        [{ tile: nil, rule: :start, player: nil }, nil]
      ],
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
    assert \
      game.errors.full_messages.include?(I18n.t('game.invalid_word'))
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0]['tile'])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'adds errors for overlapping tiles and does not update records' do
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
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.overlapping_tiles'))
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end

  test 'adds errors for non-existent hand tile and does not update records' do
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
    assert \
      game.errors.full_messages.include?(I18n.t('game.move.must_be_from_hand'))
    assert_equal('d', board[0][0]['tile'])
    assert_nil(board[0][1])
    assert_nil(board[1][0])
    assert_nil(board[1][1])
    assert_equal(%w[a a c c], player1.hand)
    assert_equal(player1, game.current_player)
  end
end
