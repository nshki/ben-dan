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

# Represents a relationship between two `User` records.
class Friend < ApplicationRecord
  after_destroy :destroy_reciprocal_record

  validates :user_id, :friend_id, presence: true

  private

  # Destroys the reciprocal record, if any.
  #
  # @return {void}
  def destroy_reciprocal_record
    reciprocal = Friend.find_by(user_id: friend_id, friend_id: user_id)
    reciprocal&.destroy
  end
end
