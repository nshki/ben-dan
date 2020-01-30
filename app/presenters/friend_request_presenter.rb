# frozen_string_literal: true

# Handles friend request-related data logic so views don't have to.
class FriendRequestPresenter
  # Constructor.
  #
  # @param {Friend} friend_request - Friend record
  # @return {FriendRequestPresenter} - Instance
  def initialize(friend_request)
    @friend_request = friend_request
  end

  # Returns the name of the requester.
  #
  # @return {String} - Name of requester
  def name
    @friend_request.user.username
  end

  # Returns the ID of the friend request.
  #
  # @return {Integer} - ID of friend request
  def id
    @friend_request.id
  end
end
