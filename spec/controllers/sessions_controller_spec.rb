# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe '#new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    let(:valid_password) { 'password' }
    let(:invalid_password) { 'wrongpassword' }

    subject { post :create, params: { email: user.email, password: } }

    context 'with valid credentials' do
      let(:password) { valid_password }

      it 'logs in the user and redirects to the root path' do
        subject
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('sessions.login.success'))
      end
    end

    context 'with invalid credentials' do
      let(:password) { invalid_password }

      it 're-renders the new template with an alert' do
        subject
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq(I18n.t('sessions.messages.errors'))
      end
    end
  end

  describe '#destroy' do
    before { session[:user_id] = user.id }

    it 'logs out the user and redirects to the root path' do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq(I18n.t('sessions.logout.success'))
    end
  end
end
