class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[edit update destroy]
  before_action :set_users_by_letter, only: %i[new create edit update]

  def index
    @groups = current_user.groups.uniq

    return if params[:id].blank?

    @selected_group = current_user.groups.find_by(id: params[:id])
    @tasks = @selected_group&.tasks
  end

  def new
    @group = current_user.groups.new
  end

  def edit; end

  def create
    @group = current_user.groups.new(group_params)
    @group.user = current_user

    if insufficient_members?(group_params[:user_ids])
      flash.now[:alert] = t('alert.member_count_insufficient')
      render :new and return
    end

    if @group.save
      add_current_user_to_group
      redirect_to groups_path, notice: t('.success')
    else
      render :new, alert: t('alert.creation_failed')
    end
  end

  def update
    updated_user_ids = (params[:group][:user_ids] || []).map(&:to_i)

    updated_user_ids << @group.user.id unless updated_user_ids.include?(@group.user.id)
    updated_user_ids << current_user.id unless updated_user_ids.include?(current_user.id)

    if @group.update(group_params.merge(user_ids: updated_user_ids))
      redirect_to groups_path(id: @group.id), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: t('.success')
  end

  def remove_user
    @group = Group.find(params[:id])
    user = User.find(params[:user_id])

    if user == @group.user
      redirect_to groups_path(id: @group.id), alert: t('.cannot_remove_leader')
    elsif @group.users.include?(user)
      @group.users.delete(user)
      redirect_to groups_path(id: @group.id), notice: t('.success', email: user.email)
    else
      redirect_to groups_path(id: @group.id), alert: t('.failure')
    end
  end

  private

  def set_group
    @group = current_user.groups.find_by(id: params[:id])
    render file: Rails.public_path.join('404.html').to_s, status: :not_found if @group.nil?
  end

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end

  def set_users_by_letter
    @users_by_letter = User.where.not(id: current_user.id)
                           .order(:email)
                           .group_by { |user| user.email[0].upcase }
  end

  def insufficient_members?(user_ids)
    selected_user_ids = (user_ids || []).compact_blank
    total_members = selected_user_ids.size + 1
    total_members < 2
  end

  def add_current_user_to_group
    @group.users << current_user unless @group.users.include?(current_user)
  end
end
