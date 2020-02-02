# frozen_string_literal: true

require 'application_system_test_case'

class SessionManagementTest < ApplicationSystemTestCase
  test 'can login and logout' do
    FactoryBot.create(:user, u: 'username', p: 'password')

    login_with(username: 'username', password: 'password')
    click_on('username')
    click_on('Logout')

    assert_field('Username')
    assert_field('Password')
  end
end
