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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = FactoryBot.build(:user)

    assert(user.valid?)
  end

  test 'invalid without username' do
    user = FactoryBot.build(:user, username: nil)

    assert_not(user.valid?)
  end
end
