# frozen_string_literal: true

require 'test_helper'

class FriendQueryTest < ActiveSupport::TestCase
  test 'returns confirmed friends of a user' do
    user = FactoryBot.create(:user, username: 'user')
    friend = FactoryBot.create(:user, username: 'fren')
    rando = FactoryBot.create(:user, username: 'rando')
    user_request = FactoryBot.create(:friend, user: user, friend: friend)
    friend_request = user_request.reciprocal
    rando_request =
      FactoryBot.create(:friend_request, user: rando, friend: user)

    friends = FriendQuery.new(user).friends

    assert(friends.include?(user_request))
    assert(friends.exclude?(friend_request))
    assert(friends.exclude?(rando_request))
  end

  test 'returns friend requests to a user' do
    user = FactoryBot.create(:user, username: 'user')
    friend = FactoryBot.create(:user, username: 'fren')
    rando = FactoryBot.create(:user, username: 'rando')
    user_request = FactoryBot.create(:friend, user: user, friend: friend)
    friend_request = user_request.reciprocal
    rando_request =
      FactoryBot.create(:friend_request, user: rando, friend: user)

    requests = FriendQuery.new(user).requests

    assert(requests.include?(rando_request))
    assert(requests.exclude?(user_request))
    assert(requests.exclude?(friend_request))
  end
end
