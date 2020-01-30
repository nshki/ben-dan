# frozen_string_literal: true

# Handles friend-related data logic so views don't have to.
class FriendPresenter
  # Constructor.
  #
  # @param {Friend} friend - Friend record
  # @return {FriendPresenter} - Instance
  def initialize(friend)
    @friend = friend
  end

  # Returns the name of the friend. Fetches the User record identified by the
  # `friend_id` foreign key, since `user_id` should be the "you."
  #
  # @return {String} - Name of friend
  def name
    @friend.friend.username
  end

  # Returns the ID of the friend.
  #
  # @return {Integer} - ID of friend
  def id
    @friend.friend.id
  end
end
