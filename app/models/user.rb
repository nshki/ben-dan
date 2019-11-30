# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  password_digest :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Represents users of the application.
class User < ApplicationRecord
  has_secure_password

  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users

  validates :username, presence: true, uniqueness: true
end
