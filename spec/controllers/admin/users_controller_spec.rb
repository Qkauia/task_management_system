# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) do
    create(:user, email: "admin_#{SecureRandom.uuid}@example.com", role: 'admin', password: 'password',
                  password_confirmation: 'password')
  end
  let(:user) do
    create(:user, email: "user_#{SecureRandom.uuid}@example.com", role: 'user', password: 'password',
                  password_confirmation: 'password')
  end
  let(:other_admin) do
    create(:user, email: "admin2_#{SecureRandom.uuid}@example.com", role: 'admin', password: 'password',
                  password_confirmation: 'password')
  end

  before do
    session[:user_id] = admin.id
  end

  describe '#index' do
    it 'assigns all users except the current admin to @users' do
      get :index
      expect(assigns(:users)).to contain_exactly(user, other_admin)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#edit' do
    it 'assigns the requested user to @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    let(:user) { create(:user, role: 'user') }

    context 'when updating the user role' do
      it 'updates the user role and redirects to the users index' do
        patch :update, params: { id: user.id, user: { role: 'admin' } }
        expect(user.reload.role).to eq('admin')
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq(I18n.t('admin.users.update.success'))
      end
    end

    context 'when updating another user' do
      let(:valid_params) { { email: 'new_email@example.com' } }

      it 'updates the user and redirects to the users index' do
        patch :update, params: { id: user.id, user: valid_params }
        expect(user.reload.email).to eq('new_email@example.com')
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq(I18n.t('admin.users.update.success'))
      end

      it 're-renders the edit template when update fails' do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        patch :update, params: { id: user.id, user: valid_params }
        expect(response).to render_template(:edit)
      end
    end

    context 'when attempting to update self' do
      it 'does not update and redirects with an alert' do
        patch :update, params: { id: admin.id, user: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.update.cannot_update_self'))
      end
    end
  end

  describe '#destroy' do
    context 'when destroying another user' do
      it 'deletes the user and redirects to the users index' do
        delete :destroy, params: { id: user.id }
        expect(User).not_to exist(user.id)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq(I18n.t('admin.users.destroy.success'))
      end
    end

    context 'when attempting to destroy self' do
      it 'does not delete and redirects with an alert' do
        delete :destroy, params: { id: admin.id }
        expect(User).to exist(admin.id)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.cannot_delete_self'))
      end
    end

    context 'when attempting to destroy the last admin' do
      before do
        allow(User).to receive(:where).and_call_original
        allow(User).to receive(:where).with(hash_including(role: 'admin')).and_wrap_original do |original_method, *args|
          original_method.call(*args).where(deleted_at: nil)
        end
      end

      it 'does not delete and redirects with an alert' do
        delete :destroy, params: { id: admin.id }
        expect(User).to exist(admin.id)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.destroy.cannot_delete_self'))
      end
    end
  end

  describe 'authorization' do
    context 'when non-admin user tries to access' do
      before do
        session[:user_id] = user.id
      end

      it 'redirects to the root path with an alert' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.unauthorized'))
      end
    end
  end
end
