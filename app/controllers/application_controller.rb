# frozen_string_literal: true

# Defines base behavior for all controllers.
class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  # Returns the currently logged in user, if any.
  #
  # @return {User} - Currently logged in User or nil
  def current_user
    User.find_by(id: cookies.encrypted[:user_id])
  end

  # Denotes if a User is currently signed in.
  #
  # @return {Boolean} - True if logged in, false otherwise
  def signed_in?
    current_user.present?
  end

  # Requires a user to be signed in before proceeding.
  #
  # @return{void}
  def authenticate_user
    redirect_to(new_session_path) unless signed_in?
  end
end
