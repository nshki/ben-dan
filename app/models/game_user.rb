# frozen_string_literal: true

# == Schema Information
#
# Table name: game_users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint
#  user_id    :bigint
#

# Represents a player's involvement in an individual game.
class GameUser < ApplicationRecord
  belongs_to :game
  belongs_to :user
end
