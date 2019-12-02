# frozen_string_literal: true

# Handles game actions.
class GamesController < ApplicationController
  before_action :authenticate_user

  # @route GET / (root)
  # @route GET /games (games)
  def index; end

  # @route GET /games/new (new_game)
  def new; end

  # @route POST /games (games)
  def create; end

  # @route GET /games/:id/edit (edit_game)
  def edit; end

  # @route PATCH /games/:id (game)
  # @route PUT /games/:id (game)
  def update; end
end
