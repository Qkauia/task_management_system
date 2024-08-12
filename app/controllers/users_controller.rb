class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

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
    @user = current_user

    if @user.authenticate(params[:user][:current_password])
      if @user.update(user_params)
        redirect_to root_path, notice: t('users.password.update_success')
      else
        flash.now[:alert] = t('users.password.update_failed')
        render :edit
      end
    else
      flash.now[:alert] = t('users.password.current_password_incorrect')
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
