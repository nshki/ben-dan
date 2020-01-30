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

FactoryBot.define do
  factory :friend do
    confirmed { true }
  end

  factory :friend_request, parent: :friend do
    confirmed { false }
  end
end
