# frozen_string_literal: true

require 'application_system_test_case'

# rubocop:disable Style/ClassAndModuleChildren
class Game::NewTest < ApplicationSystemTestCase
  # rubocop:enable Style/ClassAndModuleChildren
  test 'can start new game' do
    FactoryBot.create(:user, u: 'me', p: 'password')
    FactoryBot.create(:user, u: 'rival')

    login_with(username: 'me', password: 'password')
    visit(new_game_path)
    select('rival', from: 'Opponent')
    click_on('Start Game')

    assert_css('.board')
  end
end
