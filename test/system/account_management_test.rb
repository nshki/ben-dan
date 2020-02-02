# frozen_string_literal: true

require 'application_system_test_case'

class AccountManagementTest < ApplicationSystemTestCase
  test 'can update account' do
    FactoryBot.create(:user, u: 'me', p: 'password')

    login_with(username: 'me', password: 'password')
    click_on('me')
    click_on('Account')
    fill_in('Password', with: 'password2')
    fill_in('Password Confirmation', with: 'password2')
    click_on('Save')

    assert_text(I18n.t('account.updated'))
  end
end
