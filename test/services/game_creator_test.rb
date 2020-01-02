# frozen_string_literal: true

require 'test_helper'

class GameCreatorTest < ActiveSupport::TestCase
  test 'creates a new game given board dimensions and users' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    game = GameCreator.call(users: [user1, user2])

    assert(game.is_a?(Game))
    assert_equal(15, game.board.length)
    assert_equal(15, game.board.first.length)
    assert(game.users.include?(user1))
    assert(game.users.include?(user2))
    assert(game.current_turn_user.in?([user1, user2]))
    assert_equal(84, game.tile_bag.count)
    assert_equal(8, game.player(user1).hand.count)
    assert_equal(8, game.player(user2).hand.count)
  end
end
