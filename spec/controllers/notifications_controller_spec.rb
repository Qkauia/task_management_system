# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  let(:notification) { create(:notification, user: user) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    let!(:unread_notification) { create(:notification, user: user, read_at: nil) }
    let!(:read_notification) { create(:notification, user: user, read_at: Time.current) }
    subject { get :index }
    it 'assigns unread notifications to @notifications' do
      subject
      expect(assigns(:notifications)).to include(unread_notification)
      expect(assigns(:notifications)).not_to include(read_notification)
    end

    it 'renders the index template' do
      subject
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #mark_as_read' do
    context 'when the notification belongs to the current user' do
      it 'marks the notification as read' do
        post :mark_as_read, params: { id: notification.id }
        notification.reload
        expect(notification.read_at).not_to be_nil
        expect(flash[:notice]).to eq(I18n.t('notification.marked_as_read'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the notification does not belong to the current user' do
      let(:other_user) { create(:user) }
      let(:other_notification) { create(:notification, user: other_user) }
    
      it 'redirects to the not found page when notification is not found' do
        post :mark_as_read, params: { id: other_notification.id }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('404')  # 假設你顯示 404 頁面
      end
    end
  end
end
