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
    user.tasks.each do |task|
      if task.end_time <= Time.current && user.notifications.where(task: task).blank?
        user.notifications.create(task: task, message: "〖 #{task.title} 〗" + t('notification.task_end_time_has_passed').to_s)
      elsif (task.end_time - 1.day) <= Time.current && user.notifications.where(task: task).blank?
        user.notifications.create(task: task, message: "〖 #{task.title} 〗" + t('notification.task_is_due_soon').to_s)
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
    if current_user
      @notifications = current_user.notifications.unread.includes(:task).limit(6)
      @unread_count = @notifications.size
    end
  end
end
