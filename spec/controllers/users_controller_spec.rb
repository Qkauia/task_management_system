require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user, password: 'oldpassword', password_confirmation: 'oldpassword') }

  describe '#new' do
    it 'assigns a new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#edit' do
    before do
      session[:user_id] = user.id
    end

    it 'assigns the current user to @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      let(:valid_attributes) { attributes_for(:user) }

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'sets the session user_id' do
        post :create, params: { user: valid_attributes }
        expect(session[:user_id]).to eq(assigns(:user).id)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { attributes_for(:user, email: '') }

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it 're-renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#update' do
    before do
      session[:user_id] = user.id
    end

    context 'with valid current password and new passwords' do
      let(:valid_params) do
        { user: { current_password: 'oldpassword', password: 'newpassword', password_confirmation: 'newpassword' } }
      end

      subject { patch :update, params: { id: user.id }.merge(valid_params) }

      it 'updates the user password' do
        subject
        expect(user.reload.authenticate('newpassword')).to be_truthy
      end

      it 'redirects to the root path with a success message' do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('users.password.update_success'))
      end
    end

    context 'with incorrect current password' do
      let(:invalid_params) do
        { user: { current_password: 'wrongpassword', password: 'newpassword', password_confirmation: 'newpassword' } }
      end

      subject { patch :update, params: { id: user.id }.merge(invalid_params) }

      it 'does not update the user password' do
        subject
        expect(user.reload.authenticate('newpassword')).to be_falsey
      end

      it 're-renders the edit template with an alert message' do
        subject
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq(I18n.t('users.password.current_password_incorrect'))
      end
    end

    context 'with blank password fields' do
      let(:blank_password_params) do
        { user: { current_password: 'oldpassword', password: '', password_confirmation: '' } }
      end

      subject { patch :update, params: { id: user.id }.merge(blank_password_params) }

      it 'does not update the user password' do
        subject
        expect(user.reload.authenticate('oldpassword')).to be_truthy
      end

      it 're-renders the edit template with an alert message' do
        subject
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq(I18n.t('users.password.fields_cannot_be_blank'))
      end
    end
  end
end
