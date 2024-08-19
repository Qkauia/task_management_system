class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks.includes(:tags)
                         .where(deleted_at: nil)
                         .with_status(params[:status])
                         .search(params[:query])
                         .order(sort_column => sort_direction)
                         .sorted
                         .page(params[:page])
                         .per(10)

    return if params[:tag_id].blank?

    @tasks = @tasks.joins(:tags).where(tags: { id: params[:tag_id] })
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
    if @task.update(task_params)
      create_new_tag_if_needed
      redirect_to tasks_path, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('.success')
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :start_time, :end_time, :priority, :status, tag_ids: [])
  end

  def create_new_tag_if_needed
    return if params[:task][:new_tag].blank?

    new_tag = Tag.find_or_create_by(name: params[:task][:new_tag])
    @task.tags << new_tag unless @task.tags.include?(new_tag)
  end

  def sort_column
    %w[title priority status start_time end_time].include?(params[:sort]) ? params[:sort] : "priority"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
