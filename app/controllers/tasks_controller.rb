class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :users_by_letter, only: %i[new edit]

  def index
    @tasks = Task.owned_and_shared_by(current_user)
                 .with_shared_count
                 .filtered_by_status(params[:status])
                 .filtered_by_query(params[:query])
                 .filter_by_tag(params[:tag_id])
                 .distinct
                 .order("#{sort_column} #{sort_direction}")
                 .page(params[:page])
                 .per(10)
  end

  def show; end

  def new
    @task = current_user.tasks.new
  end

  def edit; end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      create_new_tag_if_needed
      redirect_to tasks_path, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.user == current_user || @task.task_users.find_by(user: current_user)&.can_edit
      if @task.update(task_params)
        create_new_tag_if_needed
        redirect_to tasks_path, notice: t('.success')
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to tasks_path, alert: t('.insufficient_permissions')
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('.success')
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id]) || current_user.shared_tasks.find_by(id: params[:id])
    redirect_to tasks_path, alert: t('.not_found') unless @task
  end

  def task_params
    params.require(:task).permit(:title, :content, :start_time, :end_time, :priority, :status, tag_ids: [], shared_user_ids: [])
  end

  def create_new_tag_if_needed
    return if params[:task][:new_tag].blank?

    new_tag = Tag.find_or_create_by(name: params[:task][:new_tag])
    @task.tags << new_tag unless @task.tags.include?(new_tag)
  end

  def users_by_letter
    @users_by_letter = User.order(:email).group_by { |user| user.email[0].upcase }
  end

  def sort_column
    if params[:sort] == "shared_count"
      "shared_count"
    else
      %w[title priority status start_time end_time].include?(params[:sort]) ? params[:sort] : "priority"
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
