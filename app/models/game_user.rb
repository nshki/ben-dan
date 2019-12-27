# frozen_string_literal: true

# == Schema Information
#
# Table name: game_users
#
#  id         :bigint           not null, primary key
#  hand       :string           default([]), is an Array
#  score      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint
#  user_id    :bigint
#

# Represents a player's involvement in an individual game.
class GameUser < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validate :validate_hand

  private

  # Validates that the hand is:
  #   - filled with only single chars
  #
  # @return {void}
  def validate_hand
    hand.each do |tile|
      unless tile&.length == 1
        errors.add(:hand, 'can only contain single characters') && break
      end
    end
  end
end
