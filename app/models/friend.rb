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
  after_commit \
    :ensure_reciprocal_record,
    on: %i[create update],
    if: proc { saved_change_to_attribute?(:confirmed, from: false, to: true) }
  after_destroy_commit :destroy_reciprocal_record

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, :friend_id, presence: true

  # Gets the reciprocal record, if it exists.
  #
  # @return {Friend} - Reciprocal record
  def reciprocal
    Friend.find_by(user_id: friend_id, friend_id: user_id)
  end

  private

  # Creates a reciprocal record (becomes a friend).
  #
  # @return {void}
  def ensure_reciprocal_record
    if (friend = Friend.find_by(user_id: friend_id, friend_id: user_id))
      friend.update(confirmed: true)
    else
      Friend.create(user_id: friend_id, friend_id: user_id, confirmed: true)
    end
  end

  # Destroys the reciprocal record, if any.
  #
  # @return {void}
  def destroy_reciprocal_record
    reciprocal = Friend.find_by(user_id: friend_id, friend_id: user_id)
    reciprocal&.destroy
  end
end
