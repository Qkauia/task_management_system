module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user.admin? && User.where(role: :admin).count == 1
        redirect_to admin_users_path, alert: t('.last_admin')
      else
        @user.destroy
        redirect_to admin_users_path, notice: t('.success')
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

    def authorize_admin!
      return if current_user.admin?

      redirect_to root_path, alert: t('admin.users.unauthorized')
    end
  end
end
