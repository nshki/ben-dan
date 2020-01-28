# frozen_string_literal: true

require 'application_system_test_case'

class GamePlayTest < ApplicationSystemTestCase
  test 'can undo tile placements' do
    you = FactoryBot.create(:user, u: 'me', p: 'password')
    opponent = FactoryBot.create(:user, u: 'rival')
    game = GameCreator.call(users: [you, opponent])
    game.update(current_turn_user: you)

    login_with(username: 'me', password: 'password')
    visit(edit_game_path(game))
    first('.game-ui__hand .tile').click
    first('.board__tile').click
    click_on('Undo')

    assert_selector('.game-ui__hand .tile', count: 8)
    assert_selector('.board .tile', count: 0)
  end

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
    first(tile, text: 'H').click
    find('[data-col="7"][data-row="7"]').click
    first(tile, text: 'E').click
    find('[data-col="8"][data-row="7"]').click
    first(tile, text: 'L').click
    find('[data-col="9"][data-row="7"]').click
    first(tile, text: 'L').click
    find('[data-col="10"][data-row="7"]').click
    first(tile, text: 'O').click
    find('[data-col="11"][data-row="7"]').click
    click_on('Move!')

    assert_text("me\n16")
  end
end
