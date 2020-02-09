# frozen_string_literal: true

require 'application_system_test_case'

class SessionManagementTest < ApplicationSystemTestCase
  test 'can login and logout' do
    FactoryBot.create(:user, u: 'username', p: 'password')

    login_with(username: 'username', password: 'password')
    click_on('username')
    click_on('Logout')

    assert_text(I18n.t('session.logged_out'))
  end

  test 'invalid credentials results in error' do
    login_with(username: 'ghost', password: 'password')

    assert_text(I18n.t('session.invalid_credentials'))
  end
end
