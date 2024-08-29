# frozen_string_literal: true

# This controller manages the users within the admin namespace.
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('sessions.login.success')
      check_task_notifications(current_user)
    else
      flash.now[:alert] = t('sessions.messages.errors')
      render :new
    end
  end

  def destroy
    current_user&.notifications&.destroy_all
    session[:user_id] = nil
    redirect_to root_path, notice: t('sessions.logout.success')
  end
end
