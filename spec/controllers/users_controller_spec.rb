# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    let(:valid_params) { { email: 'test@example.com', password: 'password', password_confirmation: 'password' } }
    let(:invalid_params) { { email: '', password: '', password_confirmation: '' } }

    subject { post :create, params: { user: params } }

    context 'with valid attributes' do
      let(:params) { valid_params }

      it 'creates a new user and returns a success message' do
        post :create, params: { user: valid_params }
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to eq(I18n.t('users.registration.success'))
      end
    end

    context 'with invalid attributes' do
      let(:params) { invalid_params }

      it 'does not create a user and returns an error message' do
        post :create, params: { user: invalid_params }
        expect(response).to have_http_status(422)
        expect(flash[:alert]).to eq(I18n.t('users.registration.failed'))
      end
    end
  end

  describe 'PATCH/PUT #update' do
    subject { patch :update, params: { id: user.id, user: params } }

    context 'with valid current password and matching new password' do
      let(:params) { { current_password: 'password', password: 'newpassword', password_confirmation: 'newpassword' } }

      it 'updates the password and returns a success message' do
        patch :update, params: { id: user.id, user: params }
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to eq(I18n.t('users.password.update_success'))
      end
    end

    context 'with invalid current password' do
      let(:params) { { current_password: 'wrongpassword', password: 'newpassword', password_confirmation: 'newpassword' } }

      it 'does not update the password and returns an error message' do
        patch :update, params: { id: user.id, user: params }
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq(I18n.t('users.password.current_password_incorrect'))
      end
    end

    context 'with blank password or password_confirmation' do
      let(:params) { { current_password: 'password', password: '', password_confirmation: '' } }

      it 'returns an error about missing password fields' do
        patch :update, params: { id: user.id, user: params }
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq(I18n.t('users.password.fields_cannot_be_blank'))
      end
    end
  end

  describe 'PATCH/PUT #update_profile' do
    subject { patch :update_profile, params: { user: { avatar: 'new_avatar.png' } } }

    context 'with valid attributes' do
      it 'updates the profile and returns a success message' do
        patch :update_profile, params: { user: { avatar: 'new_avatar.png' } }
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to eq(I18n.t('users.avatar.updated_successfully'))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the profile and returns an error message' do
        patch :update_profile, params: { user: { email: nil } }
        expect(response).to have_http_status(422)
        expect(flash[:alert]).to eq(I18n.t('users.avatar.update_failed'))
      end
    end
  end
end
