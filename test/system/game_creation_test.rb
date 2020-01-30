# frozen_string_literal: true

require 'application_system_test_case'

class GameCreationTest < ApplicationSystemTestCase
  test 'can start new game' do
    me = FactoryBot.create(:user, u: 'me', p: 'password')
    opponent = FactoryBot.create(:user, u: 'rival')
    FactoryBot.create(:friend, user: me, friend: opponent)

    login_with(username: 'me', password: 'password')
    visit(friends_path)
    click_on('Play')

    assert_css('.board')
  end
end
