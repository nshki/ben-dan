# frozen_string_literal: true

require 'test_helper'

class GameCreatorTest < ActiveSupport::TestCase
  test 'creates a new game given board dimensions' do
    result = GameCreator.call(num_horiz_tiles: 2, num_vert_tiles: 2)

    assert(result.is_a?(Game))
  end

  test 'creates a new game given board dimensions and users' do
    user1 = FactoryBot.create(:user, username: 'User 1')
    user2 = FactoryBot.create(:user, username: 'User 2')
    result = GameCreator.call \
      num_horiz_tiles: 2,
      num_vert_tiles: 2,
      users: [user1, user2]

    assert(result.is_a?(Game))
    assert(result.current_turn_user.present?)
  end
end
