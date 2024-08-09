class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks.includes(:tags)
                         .where(deleted_at: nil)
                         .with_status(params[:status])
                         .search(params[:query])
                         .sorted
  end

  def show; end

  def new
    @task = current_user.tasks.new
  end

  def edit; end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: I18n.t('tasks.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: I18n.t('tasks.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: I18n.t('tasks.destroy.success')
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :start_time, :end_time, :priority, :status, tag_ids: [])
  end
end
