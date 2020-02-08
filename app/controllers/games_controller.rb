# frozen_string_literal: true

# Handles game actions.
class GamesController < ApplicationController
  before_action :authenticate_user
  before_action :set_game, only: %i[edit update]

  # @route GET / (root)
  # @route GET /games (games)
  def index
    @games = current_user.games
  end

  # @route POST /games (games)
  def create
    opponent = User.find_by(id: params[:opponent_id])
    game = GameCreator.call(users: [current_user, opponent])
    redirect_to(edit_game_path(game))
  end

  # @route GET /games/:id/edit (edit_game)
  def edit
    @current_player = @game.player(current_user)
    @move_active = !@game.finished? && @game.current_player == @current_player
  end

  # @route PATCH /games/:id (game)
  # @route PUT /games/:id (game)
  def update
    placements = parse_placements

    if placements.any?
      MoveMaker.call(game: @game, placements: placements)
    else
      @game.pass_turn(call_save: true)
    end

    redirect_to(edit_game_path(@game))
  end

  private

  # Parses the placements parameter.
  #
  # @return {Array<Hash>} - [{ col: Integer, row: Integer, tile: Integer }, ..]
  def parse_placements
    return [] if params[:placements].blank?

    params[:placements].map do |placement|
      tokens = placement.split(':').map(&:to_i)
      { col: tokens.first, row: tokens.second, tile: tokens.third }
    end
  end

  # Stores the current game as an instance variable.
  #
  # @return {void}
  def set_game
    @game = Game.find_by(id: params[:id])
  end
end
