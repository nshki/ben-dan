# frozen_string_literal: true

# Handles friend-related queries.
class FriendQuery
  # Constructor.
  #
  # @param {User} user - User record
  # @return {FriendQuery} - Query object
  def initialize(user)
    @user = user
  end

  # Gets friends of a user. Important to distinguish between a friend and
  # friend request.
  #
  # @return {ActiveRecord::Relation} - Friend records
  def friends
    @user.friends.where(confirmed: true)
  end

  # Gets friend requests to the given user.
  #
  # @return {ActiveRecord::Relation} - Friend records
  def requests
    Friend.where(friend: @user, confirmed: false)
  end
end
