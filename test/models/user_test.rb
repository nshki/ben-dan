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

  test 'invalid without unique username' do
    FactoryBot.create(:user, username: 'same username')
    user = FactoryBot.build(:user, username: 'same username')

    assert_not(user.valid?)
  end

  test 'invalid without password at least 4 characters long' do
    less_than = FactoryBot.build(:user, p: '123')
    equal_to = FactoryBot.build(:user, p: '1234')

    assert_not(less_than.valid?)
    assert(equal_to.valid?)
  end
end
