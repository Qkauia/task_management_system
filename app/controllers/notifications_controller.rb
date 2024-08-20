class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:mark_as_read]

  def index
    @notifications = current_user.notifications.unread.includes(:task).order(created_at: :desc).page(params[:page]).per(10)
  end

  def mark_as_read
    @notification.update(read_at: Time.current)
    redirect_back(fallback_location: root_path, notice: t('notification.marked_as_read'))
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
