# frozen_string_literal: true

# Handles friend requests.
class FriendRequestsController < ApplicationController
  before_action :authenticate_user

  # @route GET /friend_requests/new (new_friend_request)
  def new; end

  # @route POST /friend_requests (friend_requests)
  def create
    user = User.find_by(username: params[:username])
    Friend.create(user: current_user, friend: user) if user.present?

    redirect_to \
      friends_path,
      flash: { success: I18n.t('friend_request.sent', to: user.username) }
  end

  # @route DELETE /friend_requests/:id (friend_request)
  def destroy
    query = FriendQuery.new(current_user)
    friend_request = query.requests.find_by(id: params[:id])
    username = friend_request.user.username
    friend_request&.destroy

    redirect_to \
      friends_path,
      flash: { success: I18n.t('friend_request.declined', from: username) }
  end
end
