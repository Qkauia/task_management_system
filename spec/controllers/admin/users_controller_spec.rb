# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:other_admin) { create(:user, role: 'admin') }

  before do
    session[:user_id] = admin.id
  end

  describe '#index' do
    subject { get :index }

    it 'assigns all users except the current admin to @users' do
      subject
      expect(assigns(:users)).to contain_exactly(user, other_admin)
    end

    it 'renders the index template' do
      subject
      expect(response).to render_template(:index)
    end
  end

  describe '#edit' do
    subject { get :edit, params: { id: user.id } }

    it 'assigns the requested user to @user' do
      subject
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      subject
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    let(:valid_params) { { email: 'new_email@example.com' } }
    subject { patch :update, params: { id: target_user.id, user: valid_params } }

    context 'when updating the user role' do
      let(:target_user) { user }

      it 'updates the user role and redirects to the users index' do
        patch :update, params: { id: user.id, user: { role: 'admin' } }
        expect(user.reload.role).to eq('admin')
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq(I18n.t('admin.users.update.success'))
      end
    end

    context 'when updating another user' do
      let(:target_user) { user }

      it 'updates the user and redirects to the users index' do
        subject
        expect(user.reload.email).to eq('new_email@example.com')
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq(I18n.t('admin.users.update.success'))
      end

      it 're-renders the edit template when update fails' do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        subject
        expect(response).to render_template(:edit)
      end
    end

    context 'when attempting to update self' do
      let(:target_user) { admin }

      it 'does not update and redirects with an alert' do
        subject
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.update.cannot_update_self'))
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { id: target_user.id } }

    context 'when destroying another user' do
      let(:target_user) { user }

      it 'deletes the user and redirects to the users index' do
        subject
        expect(User).not_to exist(user.id)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq(I18n.t('admin.users.destroy.success'))
      end
    end

    context 'when attempting to destroy self' do
      let(:target_user) { admin }

      it 'does not delete and redirects with an alert' do
        subject
        expect(User).to exist(admin.id)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.cannot_delete_self'))
      end
    end

    context 'when attempting to destroy the last admin' do
      let(:target_user) { admin }

      before do
        allow(User).to receive(:where).and_call_original
        allow(User).to receive(:where).with(hash_including(role: 'admin')).and_wrap_original do |original_method, *args|
          original_method.call(*args).where(deleted_at: nil)
        end
      end

      it 'does not delete and redirects with an alert' do
        subject
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

      subject { get :index }

      it 'redirects to the root path with an alert' do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('admin.users.unauthorized'))
      end
    end
  end
end
