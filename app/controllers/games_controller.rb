# frozen_string_literal: true

# Handles game actions.
class GamesController < ApplicationController
  before_action :authenticate_user

  # @route GET / (root)
  # @route GET /games (games)
  def index
    @games = current_user.games
  end

  # @route GET /games/new (new_game)
  def new
    @players = User.where.not(id: current_user.id)
  end

  # @route POST /games (games)
  def create
    opponent = User.find_by(id: params[:opponent_id])
    game = GameCreator.call(users: [current_user, opponent])
    redirect_to(edit_game_path(game))
  end

  # @route GET /games/:id/edit (edit_game)
  def edit
    @game = Game.find_by(id: params[:id])
    @current_player = @game.player(current_user)
    @move_active = @game.current_player == @current_player
  end

  # @route PATCH /games/:id (game)
  # @route PUT /games/:id (game)
  def update; end
end
