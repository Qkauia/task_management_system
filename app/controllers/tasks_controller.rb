class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :users_by_letter, only: %i[new edit]
  before_action :set_groups_by_letter, only: %i[new create edit update]

  def personal
    @tasks = Task.owned_and_shared_by(current_user)
                 .with_shared_count
                 .filtered_by_status(params[:status])
                 .filtered_by_query(params[:query])
                 .filter_by_tag(params[:tag_id])
                 .order("#{sort_column} #{sort_direction}")
                 .sorted.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.json do
        render json: @tasks.map { |task|
          {
            id: task.id,
            title: task.title,
            start: task.start_time,
            end: task.end_time,
            url: task_path(task),
            color: case task.status
                   when 'pending' then '#808080'
                   when 'in_progress' then '#728C72'
                   when 'completed' then '#A2634C'
                   else '#000000'
                   end
          }
        }
      end
    end
  end

  def show
    return if @task_accessible

    redirect_to personal_tasks, alert: t('alert.not_found')
  end

  def new
    @task = current_user.tasks.new
  end

  def edit; end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      create_new_tag_if_needed
      redirect_to personal_tasks_path, notice: t('.success')
    else
      render :new, alert: t('alert.creation_failed')
    end
  end

  def update
    if @task.user == current_user || @task.task_users.find_by(user: current_user)&.can_edit || current_user.groups.joins(:tasks).exists?(tasks: { id: @task.id })
      if @task.update(task_params)
        create_new_tag_if_needed
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

  private

  def set_task
    @task = Task.find_by(id: params[:id])

    if @task.nil?
      redirect_to personal_tasks_path, alert: t('alert.not_found')
    else
      @task_accessible = current_user.id == @task.user_id ||
                         @task.shared_users.include?(current_user) ||
                         @task.groups.any? { |group| group.users.include?(current_user) }
    end
  end

  def task_params
    params.require(:task).permit(:title, :content, :start_time, :end_time, :priority, :status, tag_ids: [], shared_user_ids: [], group_ids: []).tap do |whitelisted|
      whitelisted[:group_ids] ||= []
    end
  end

  def create_new_tag_if_needed
    return if params[:task][:new_tag].blank?

    new_tag = Tag.find_or_create_by(name: params[:task][:new_tag])
    @task.tags << new_tag unless @task.tags.include?(new_tag)
  end

  def users_by_letter
    @users_by_letter = User.where.not(id: current_user.id)
                           .order(:email)
                           .group_by { |user| user.email[0].upcase }
  end

  def set_groups_by_letter
    @groups_by_letter = current_user.groups.order(:name).group_by { |group| group.name[0].upcase }
  end
end
