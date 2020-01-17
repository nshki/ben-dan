# frozen_string_literal: true

require 'application_system_test_case'

# rubocop:disable Style/ClassAndModuleChildren
class Game::PlayTest < ApplicationSystemTestCase
  # rubocop:enable Style/ClassAndModuleChildren
  test 'can make opening move' do
    you = FactoryBot.create(:user, u: 'me', p: 'password')
    opponent = FactoryBot.create(:user, u: 'rival')
    game = GameCreator.call(users: [you, opponent])
    game.update(current_turn_user: you)
    game.player(you).update(hand: %w[h e l l o a b c])
    FactoryBot.create(:word, spelling: 'hello')

    login_with(username: 'me', password: 'password')
    visit(edit_game_path(game))
    tile = '.game-ui__hand .tile'
    first(tile, text: 'h').click
    find('[data-col="7"][data-row="7"]').click
    first(tile, text: 'e').click
    find('[data-col="8"][data-row="7"]').click
    first(tile, text: 'l').click
    find('[data-col="9"][data-row="7"]').click
    first(tile, text: 'l').click
    find('[data-col="10"][data-row="7"]').click
    first(tile, text: 'o').click
    find('[data-col="11"][data-row="7"]').click
    click_on('Move!')

    assert_text("me\n16")
  end
end
