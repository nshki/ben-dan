# frozen_string_literal: true

require 'test_helper'

class GameCreatorTest < ActiveSupport::TestCase
  test 'creates a new game given board dimensions and users' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    result = GameCreator.call \
      num_horiz_tiles: 2,
      num_vert_tiles: 2,
      users: [user1, user2]

    assert(result.is_a?(Game))
    assert_equal(2, result.board.length)
    assert_equal(2, result.board.first.length)
    assert(result.users.include?(user1))
    assert(result.users.include?(user2))
    assert(result.current_turn_user.in?([user1, user2]))
    assert_equal(84, result.tile_bag.count)
    assert_equal(8, result.game_users.find_by(user: user1).hand.count)
    assert_equal(8, result.game_users.find_by(user: user2).hand.count)
  end
end
