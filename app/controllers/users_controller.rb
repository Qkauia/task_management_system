# frozen_string_literal: true

# This controller manages the users within the admin namespace.
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update edit_profile update_profile]

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: t('users.registration.success')
    else
      render :new
    end
  end

  def update
    if @user.authenticate(params[:user][:current_password])
      if passwords_present?
        if @user.update(user_params)
          redirect_to root_path, notice: t('users.password.update_success')
        else
          flash.now[:alert] = t('users.password.update_failed')
          render :edit
        end
      else
        flash.now[:alert] = t('users.password.fields_cannot_be_blank')
        render :edit
      end
    else
      flash.now[:alert] = t('users.password.current_password_incorrect')
      render :edit
    end
  end

  def edit_profile; end

  def update_profile
    if @user.update(profile_params)
      redirect_to root_path, notice: t('users.avatar.updated_successfully')
    else
      flash.now[:alert] = t('users.avatar.update_failed')
      Rails.logger.debug @user.errors.full_messages
      render :edit_profile
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end

  def profile_params
    params.require(:user).permit(:avatar)
  end

  def passwords_present?
    params[:user][:password].present? && params[:user][:password_confirmation].present?
  end
end
