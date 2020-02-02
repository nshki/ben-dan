# frozen_string_literal: true

# Account management.
class AccountsController < ApplicationController
  before_action :authenticate_user
  before_action :set_account

  # @route GET /account/edit (edit_account)
  def edit; end

  # @route PATCH /account (account)
  # @route PUT /account (account)
  def update
    if @account.update(account_params)
      redirect_to(edit_account_path, notice: I18n.t('account.updated'))
    else
      render(:edit)
    end
  end

  private

  # Sets account-related instance variables.
  #
  # @return {void}
  def set_account
    @account = current_user
  end

  # Whitelisted parameters.
  #
  # @return {ActiveSupport::Parameters} - Whitelisted parameters
  def account_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
