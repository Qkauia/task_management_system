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
      if prevent_self_action
        redirect_to admin_users_path, alert: t('.cannot_update_self')
      elsif @user.update(user_params)
        redirect_to admin_users_path, notice: t('.success')
      else
        render :edit
      end
    end
    
    def destroy
      if prevent_self_action
        redirect_to admin_users_path, alert: t('.cannot_delete_self')
      elsif last_admin?
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

      redirect_to root_path, alert: t('.unauthorized')
    end

    def prevent_self_action
      @user = User.find(params[:id])
      @user == current_user
    end

    def last_admin?
      @user.admin? && User.where(role: :admin).count == 1
    end

  end
end
