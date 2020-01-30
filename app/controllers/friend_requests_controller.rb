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
    notice =
      if current_user == user
        # Self request.
        I18n.t('friend_request.self')
      elsif user.present?
        # User exists.
        send_friend_request(user)
      else
        # User doesn't exist. Still returning a request sent message to
        # obfuscate the existence of users.
        I18n.t('friend_request.sent', to: username)
      end

    redirect_to(friends_path, notice: notice)
  end

  # @route DELETE /friend_requests/:id (friend_request)
  def destroy
    query = FriendQuery.new(current_user)
    friend_request = query.requests.find_by(id: params[:id])
    username = friend_request.user.username
    friend_request&.destroy

    redirect_to \
      friends_path,
      notice: I18n.t('friend_request.declined', from: username)
  end

  private

  # Sends a friend request to the given user.
  #
  # @param {User} user - Befriended
  # @return {String} - Result text
  def send_friend_request(user)
    notice = I18n.t('friend_request.sent', to: user.username)

    # Send a new request.
    friend_request = Friend.create(user: current_user, friend: user)

    # Handle the mutual request case.
    if friend_request.reciprocal.present?
      friend_request.update(confirmed: true)
      notice = I18n.t('friend_request.accepted', from: user.username)
    end

    notice
  end
end
