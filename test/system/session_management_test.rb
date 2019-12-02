# frozen_string_literal: true

require 'application_system_test_case'

class SessionManagementTest < ApplicationSystemTestCase
  test 'can login and logout' do
    FactoryBot.create \
      :user,
      username: 'username',
      password: 'password',
      password_confirmation: 'password'

    visit(new_session_path)
    fill_in('Username', with: 'username')
    fill_in('Password', with: 'password')
    click_button('Login')
    click_on('Logout')

    assert_field('Username')
    assert_field('Password')
  end
end
