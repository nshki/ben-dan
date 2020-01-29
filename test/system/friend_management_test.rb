# frozen_string_literal: true

require 'application_system_test_case'

class FriendManagementTest < ApplicationSystemTestCase
  test 'can send friend request' do
    me = FactoryBot.create(:user, u: 'me', p: 'password')
    fren = FactoryBot.create(:user, u: 'fren', p: 'password')

    login_with(username: 'me', password: 'password')
    visit(new_friend_request_path)
    fill_in('Username', with: 'fren')
    click_on('Add Friend')

    assert_text(I18n.t('friend_request.sent', to: fren.username))
    assert_equal(1, me.friends.count)
    assert_equal(0, fren.friends.count)
  end

  test 'can accept friend request' do
    me = FactoryBot.create(:user, u: 'me', p: 'password')
    fren = FactoryBot.create(:user, u: 'fren', p: 'password')
    FactoryBot.create(:friend_request, user: fren, friend: me)

    login_with(username: 'me', password: 'password')
    visit(friends_path)
    click_on('Accept')

    assert_text(I18n.t('friend_request.accepted', friend: fren.username))
    assert_equal(1, me.friends.count)
    assert_equal(1, fren.friends.count)
  end

  test 'can decline friend request' do
    me = FactoryBot.create(:user, u: 'me', p: 'password')
    fren = FactoryBot.create(:user, u: 'fren', p: 'password')
    FactoryBot.create(:friend_request, user: fren, friend: me)

    login_with(username: 'me', password: 'password')
    visit(friends_path)
    click_on('Decline')

    assert_text(I18n.t('friend_request.declined', from: fren.username))
    assert_equal(0, me.friends.count)
    assert_equal(0, fren.friends.count)
  end

  test 'can remove friend' do
    me = FactoryBot.create(:user, u: 'me', p: 'password')
    fren = FactoryBot.create(:user, u: 'fren', p: 'password')
    FactoryBot.create(:friend, user: fren, friend: me)

    login_with(username: 'me', password: 'password')
    visit(friends_path)
    click_on('Remove')

    assert_text(I18n.t('friend.removed', username: fren.username))
    assert_equal(0, me.friends.count)
    assert_equal(0, fren.friends.count)
  end
end
