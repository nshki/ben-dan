# frozen_string_literal: true

# Handles user sessions.
class SessionsController < ApplicationController
  # @route GET /sessions/new (new_session)
  def new; end

  # @route POST /sessions (sessions)
  def create
    username = params[:username]
    password = params[:password]
    user = User.find_by(username: username)
    login_failed && return if user.blank? || !user.authenticate(password)

    session[:user_id] = user.id
    redirect_to(games_path)
  end

  # @route DELETE /sessions/:id (session)
  def destroy
    session[:user_id] = nil
    flash[:success] = 'You have logged out.'
    redirect_to(new_session_path)
  end

  private

  # Sets failure state and re-renders the login form.
  #
  # @return {void}
  def login_failed
    flash[:error] = 'Username or password invalid'
    render(:new)
  end
end
