# frozen_string_literal: true

require 'test_helper'

class ScoreCalculatorTest < ActiveSupport::TestCase
  test 'correctly calculates score' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'aa')
    game = FactoryBot.create(:game, users: [user1, user2])
    game.update \
      current_turn_user: user1,
      board: [
        [
          { player: game.player(user1).id, tile: 'a', rule: nil },
          { player: game.player(user1).id, tile: 'a', rule: nil }
        ],
        [
          { player: game.player(user2).id, tile: 'a', rule: nil },
          nil
        ]
      ]
    placements = [{ col: 0, row: 0, tile: 0 }]

    ScoreCalculator.call \
      game: game,
      placements: placements,
      player: game.player(user1)

    assert_equal(4, game.player(user1).score)
    assert_equal(0, game.player(user2).score)
  end

  test 'correctly calculates score with double word rule' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'aa')
    game = FactoryBot.create(:game, users: [user1, user2])
    game.update \
      current_turn_user: user1,
      board: [
        [
          { player: game.player(user1).id, tile: 'a', rule: :dw },
          { player: game.player(user1).id, tile: 'a', rule: nil }
        ],
        [
          { player: game.player(user2).id, tile: 'a', rule: nil },
          nil
        ]
      ]
    placements = [{ col: 0, row: 0, tile: 0 }]

    ScoreCalculator.call \
      game: game,
      placements: placements,
      player: game.player(user1)

    assert_equal(8, game.player(user1).score)
    assert_equal(0, game.player(user2).score)
  end

  test 'correctly calculates score with triple word rule' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    FactoryBot.create(:word, spelling: 'aa')
    game = FactoryBot.create(:game, users: [user1, user2])
    game.update \
      current_turn_user: user1,
      board: [
        [
          { player: game.player(user1).id, tile: 'a', rule: :tw },
          { player: game.player(user1).id, tile: 'a', rule: nil }
        ],
        [
          { player: game.player(user2).id, tile: 'a', rule: nil },
          nil
        ]
      ]
    placements = [{ col: 0, row: 0, tile: 0 }]

    ScoreCalculator.call \
      game: game,
      placements: placements,
      player: game.player(user1)

    assert_equal(12, game.player(user1).score)
    assert_equal(0, game.player(user2).score)
  end
end
