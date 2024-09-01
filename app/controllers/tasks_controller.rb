# frozen_string_literal: true

# This controller manages the users within the admin namespace.
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :find_notification, only: %i[show]
  before_action :users_by_letter, only: %i[new edit]
  before_action :set_groups_by_letter, only: %i[new create edit update]

  def personal
    base_scope = Task.owned_and_shared_by(current_user).with_shared_count

    @tasks = load_tasks(base_scope, params).sorted.page(params[:page]).per(5)

    @important_tasks = load_tasks(base_scope.important, params)

    respond_to do |format|
      format.html
      format.json do
        render json: @tasks.map { |task| calendar_serialize_task(task) }
      end
    end
  end

  def show
    if task_accessible?
      @notification.update(read_at: Time.current) if @notification.present?
    else
      redirect_to personal_tasks_path, alert: t('alert.not_found')
    end
  end

  def new
    @task = current_user.tasks.new
  end

  def edit; end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      handle_after_save_actions
      redirect_to personal_tasks_path, notice: t('.success')
    else
      render :new, alert: t('alert.creation_failed')
    end
  end

  def update
    if task_accessible?(update: true)
      if @task.update(task_params)
        handle_after_save_actions
        redirect_to personal_tasks_path, notice: t('.success')
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to personal_tasks_path, alert: t('.insufficient_permissions')
    end
  end

  def destroy
    @task.destroy
    redirect_to personal_tasks_path, notice: t('.success')
  end

  def sort
    params[:order].each do |task_order|
      task = current_user.tasks.find_by(id: task_order[:id])
      task&.update(position: task_order[:position])
    end

    head :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: t('tasks.errors.not_found') }, status: :not_found
  end

  def update_importance
    task = Task.find_by(id: params[:id])

    if task.nil?
      render json: { error: t('tasks.errors.not_found') }, status: :not_found
      return
    end

    if task.update(important: params[:important])
      head :ok
    else
      render json: { error: t('tasks.errors.update_failed') }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to personal_tasks_path, alert: t('alert.not_found')
    else
      @task_accessible = task_accessible?
    end
  end

  def task_accessible?(update: false)
    return true if current_user.id == @task.user_id

    if update
      @task.task_users.find_by(user: current_user)&.can_edit ||
        current_user.groups.joins(:tasks).exists?(tasks: { id: @task.id })
    else
      @task.shared_users.include?(current_user) ||
        @task.groups.any? { |group| group.users.include?(current_user) }
    end
  end

  def task_params
    params.require(:task).permit(
      :title, :content, :start_time, :end_time, :priority, :status, :position, :important,
      { tag_ids: [], shared_user_ids: [], group_ids: [] }, :file
    ).tap do |whitelisted|
      whitelisted[:group_ids] ||= []
    end
  end

  def handle_after_save_actions
    create_new_tag_if_needed
    attach_file_to_task
  end

  def create_new_tag_if_needed
    return if params[:task][:new_tag].blank?

    new_tag = Tag.find_or_create_by(name: params[:task][:new_tag])
    @task.tags << new_tag unless @task.tags.include?(new_tag)
  end

  def users_by_letter
    @users_by_letter = User.grouped_by_letter(exclude_id: current_user.id)
  end

  def set_groups_by_letter
    @groups_by_letter = current_user.groups.grouped_by_letter
  end

  def attach_file_to_task
    @task.file.attach(params[:task][:file]) if params[:task][:file].present?
  end

  def find_notification
    @notification = current_user.notifications.find_by(task_id: @task.id)
  end
end
