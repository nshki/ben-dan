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

FactoryBot.define do
  factory :user do
    transient do
      u { 'Username' }
      p { 'password' }
    end

    username { u }
    password { p }
    password_confirmation { p }
  end
end
