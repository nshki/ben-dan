# frozen_string_literal: true

# Friend management.
class FriendsController < ApplicationController
  before_action :authenticate_user

  # @route GET /friends (friends)
  def index
    query = FriendQuery.new(current_user)
    @friend_requests = query.requests
    @friends = query.friends
  end

  # @route POST /friends (friends)
  def create
    unless (friend_request = Friend.find_by(id: params[:id]))
      redirect_to(friends_path, alert: I18n.t('friend_request.not_found'))
    end

    friend = friend_request.user
    Friend.create(user: current_user, friend: friend, confirmed: true)
    redirect_to \
      friends_path,
      notice: I18n.t('friend_request.accepted', from: friend.username)
  end

  # @route DELETE /friends/:id (friend)
  def destroy
    query = FriendQuery.new(current_user)
    friend = query.friends.find_by(id: params[:id])
    username = friend.friend.username
    friend.destroy

    redirect_to \
      friends_path,
      notice: I18n.t('friend.removed', username: username)
  end
end
