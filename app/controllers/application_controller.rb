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

  def check_task_notifications(user)
    owned_and_shared_tasks = Task.owned_and_shared_by(user)
    group_tasks = Task.for_user_groups(user)

    related_tasks = (owned_and_shared_tasks + group_tasks).uniq

    related_tasks.each do |task|
      next if task.end_time.blank?

      if task.end_time <= Time.current && user.notifications.where(task: task, message: t('notification.task_end_time_has_passed', task_title: task.title)).blank?
        user.notifications.create(task: task, message: t('notification.task_end_time_has_passed', task_title: task.title))
      elsif (task.end_time - 2.days) <= Time.current && user.notifications.where(task: task, message: t('notification.task_is_due_soon', task_title: task.title)).blank?
        user.notifications.create(task: task, message: t('notification.task_is_due_soon', task_title: task.title))
      end
    end
  end

  private

  def not_found
    render file: Rails.public_path.join('404.html'),
           status: :not_found,
           layout: false
  end

  def set_notifications
    return unless current_user

    @notifications = current_user.notifications.unread.includes(:task).limit(6)
    @unread_count = @notifications.size
  end
end
