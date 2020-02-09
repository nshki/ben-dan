# frozen_string_literal: true

# Handles user sessions.
class SessionsController < ApplicationController
  # @route GET /sessions/new (new_session)
  def new; end

  # @route POST /sessions (sessions)
  def create
    user = User.find_by(username: params[:username])
    login_failed && return unless user&.authenticate(params[:password])

    cookies.encrypted.permanent[:user_id] = user.id
    redirect_to(games_path)
  end

  # @route DELETE /sessions/:id (session)
  def destroy
    cookies.delete(:user_id)
    redirect_to(new_session_path, notice: I18n.t('session.logged_out'))
  end

  private

  # Invalid credentials
  #
  # @return {void}
  def login_failed
    redirect_to(new_session_path, alert: I18n.t('session.invalid_credentials'))
  end
end
