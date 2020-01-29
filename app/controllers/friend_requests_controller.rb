# frozen_string_literal: true

# Handles friend requests.
class FriendRequestsController < ApplicationController
  before_action :authenticate_user

  # @route GET /friend_requests/new (new_friend_request)
  def new; end

  # @route POST /friend_requests (friend_requests)
  def create
    username = params[:username]
    user = User.find_by(username: username)
    success = I18n.t('friend_request.sent', to: username)

    if user.present?
      friend_request = Friend.create(user: current_user, friend: user)

      # Handle the mutual request case.
      if friend_request.reciprocal.present?
        friend_request.update(confirmed: true)
        success = I18n.t('friend_request.accepted', from: username)
      end
    end

    # We're always showing a success message here to obfuscate what users exist
    # in the system.
    redirect_to(friends_path, flash: { success: success })
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
