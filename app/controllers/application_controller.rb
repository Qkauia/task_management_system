# frozen_string_literal: true

# The main application controller that other controllers inherit from.
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  helper_method :current_user
  before_action :set_locale
  before_action :set_notifications

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  # 檢查用戶的任務通知
  def check_task_notifications(user)
    tasks = fetch_related_tasks_for(user)

    tasks.each do |task|
      next if task.end_time.blank?

      if task.end_time <= Time.current
        create_notification(user, task, 'notification.task_end_time_has_passed')
      elsif (task.end_time - 2.days) <= Time.current
        create_notification(user, task, 'notification.task_is_due_soon')
      end
    end
  end

  def sort_column
    return 'shared_count' if params[:sort] == 'shared_count'
    %w[title priority status start_time end_time].include?(params[:sort]) ? params[:sort] : 'priority'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def calendar_serialize_task(task)
    {
      id: task.id,
      title: task.title,
      start: task.start_time,
      end: task.end_time,
      url: task_path(task),
      color: task_color(task)
    }
  end

  def task_color(task)
    case task.status
    when 'pending' then '#808080'
    when 'in_progress' then '#728C72'
    when 'completed' then '#A2634C'
    else '#000000'
    end
  end

  private

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def set_notifications
    return unless current_user

    @notifications = current_user.notifications.unread.includes(:task)
    @unread_count = @notifications.size
  end

  def fetch_related_tasks_for(user)
    owned_and_shared_tasks = Task.owned_and_shared_by(user)
    group_tasks = Task.for_user_groups(user)

    (owned_and_shared_tasks + group_tasks).uniq
  end

  def create_notification(user, task, message_key)
    message = t(message_key, task_title: task.title)
    return if user.notifications.exists?(task:, message:)

    user.notifications.create(task:, message:)
  end

  def load_tasks(scope, params)
    scope.filtered_by_status(params[:status])
         .filtered_by_query(params[:query])
         .filter_by_tag(params[:tag_id])
         .order("#{sort_column} #{sort_direction}")
  end
end
