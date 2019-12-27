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

require 'test_helper'

class GameUserTest < ActiveSupport::TestCase
  test 'valid instance' do
    instance = FactoryBot.build(:game_user)

    assert(instance.valid?)
  end

  test 'invalid unless hand only has single chars (or is empty)' do
    hand_nils = FactoryBot.build(:game_user, hand: [nil, nil])
    hand_multichar = FactoryBot.build(:game_user, hand: %w[aa bb])
    hand_empty = FactoryBot.build(:game_user, hand: [])
    hand_letters = FactoryBot.build(:game_user, hand: %w[a b])

    assert_not(hand_nils.valid?)
    assert_not(hand_multichar.valid?)
    assert(hand_empty.valid?)
    assert(hand_letters.valid?)
  end
end
