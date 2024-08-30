# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = User.excluding_current_user(current_user)
                   .filtered_by_query(params[:query])
                   .page(params[:page])
                   .per(10)
    end

    def edit; end

    def update
      if prevent_self_action
        redirect_to admin_users_path, alert: t('.cannot_update_self')
        return
      end

      if @user.update(user_params)
        redirect_to admin_users_path, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      if prevent_self_action
        redirect_to admin_users_path, alert: t('.cannot_delete_self')
        return
      end

      if last_admin?
        redirect_to admin_users_path, alert: t('.last_admin')
      else
        @user.destroy
        redirect_to admin_users_path, notice: t('.success')
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

    def authorize_admin!
      return if current_user.admin?

      redirect_to root_path, alert: t('admin.users.unauthorized')
    end

    def prevent_self_action
      @user == current_user
    end

    def last_admin?
      @user.admin? && User.where(role: :admin).count == 1
    end
  end
end
