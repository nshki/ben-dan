# frozen_string_literal: true

# == Schema Information
#
# Table name: friends
#
#  id         :bigint           not null, primary key
#  confirmed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_friends_on_confirmed              (confirmed)
#  index_friends_on_friend_id_and_user_id  (friend_id,user_id) UNIQUE
#  index_friends_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#

require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  test 'valid record' do
    user1 = FactoryBot.create(:user, u: '1')
    user2 = FactoryBot.create(:user, u: '2')
    friend = FactoryBot.build(:friend, user_id: user1.id, friend_id: user2.id)

    assert(friend.valid?)
  end

  test 'invalid without `user_id`' do
    user = FactoryBot.create(:user, u: '1')
    friend = FactoryBot.build(:friend, user_id: nil, friend_id: user.id)

    assert_not(friend.valid?)
  end

  test 'invalid without `friend_id`' do
    user = FactoryBot.create(:user, u: '1')
    friend = FactoryBot.build(:friend, user_id: user.id, friend_id: nil)

    assert_not(friend.valid?)
  end

  test 'creates reciprocal record when `confirmed` is true' do
    user1 = FactoryBot.create(:user, u: '1')
    user2 = FactoryBot.create(:user, u: '2')
    FactoryBot.create(:friend, user: user1, friend: user2)

    assert(Friend.find_by(user: user2, friend: user1))
  end

  test 'destroys reciprocal record when destroyed' do
    user1 = FactoryBot.create(:user, u: '1')
    user2 = FactoryBot.create(:user, u: '2')
    friend = FactoryBot.create(:friend, user: user1, friend: user2)

    friend.destroy

    assert_nil(Friend.find_by(user: user2, friend: user1))
  end
end
