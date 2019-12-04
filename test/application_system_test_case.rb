# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]

  # Helper to login as a user.
  #
  # @param {User} user - User to login as
  # @return {void}
  def login_with(username:, password:)
    visit(new_session_path)
    fill_in('Username', with: username)
    fill_in('Password', with: password)
    click_button('Login')
  end
end
