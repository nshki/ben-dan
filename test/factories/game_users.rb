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

FactoryBot.define do
  factory :game_user do
    user_id { '' }
    game_id { '' }
  end
end
