# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task, user:) }
  let(:valid_attributes) { attributes_for(:task) }
  let(:invalid_attributes) { { title: nil } }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #personal' do
    it 'assigns personal tasks and renders the personal template' do
      get :personal
      expect(assigns(:tasks)).to match_array(Task.owned_and_shared_by(user).with_shared_count)
      expect(response).to render_template(:personal)
    end
  end

  describe 'GET #show' do
    subject { get :show, params: { id: task.id } }

    context 'when the task is accessible' do
      before do
        allow(controller).to receive(:task_accessible?).and_return(true)
      end

      it 'assigns the requested task and renders the show template' do
        subject
        expect(assigns(:task)).to eq(task)
        expect(response).to render_template(:show)
      end
    end

    context 'when the task is not accessible' do
      before do
        allow(controller).to receive(:task_accessible?).and_return(false)
      end

      it 'redirects to personal tasks path with alert' do
        subject
        expect(response).to redirect_to(personal_tasks_path)
        expect(flash[:alert]).to eq(I18n.t('alert.not_found'))
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new task and renders the new template' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new task and redirects to personal tasks path' do
        expect do
          post :create, params: { task: valid_attributes }
        end.to change(Task, :count).by(1)
        expect(response).to redirect_to(personal_tasks_path)
        expect(flash[:notice]).to eq(I18n.t('tasks.create.success'))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new task and re-renders the new template' do
        post :create, params: { task: invalid_attributes }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq(I18n.t('alert.creation_failed'))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the task and redirects to personal tasks path' do
        patch :update, params: { id: task.id, task: valid_attributes }
        expect(response).to redirect_to(personal_tasks_path)
        expect(flash[:notice]).to eq(I18n.t('tasks.update.success'))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the task and re-renders the edit template' do
        patch :update, params: { id: task.id, task: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the task and redirects to personal tasks path' do
      task_to_delete = create(:task, user:)
      expect do
        delete :destroy, params: { id: task_to_delete.id }
      end.to change(Task, :count).by(-1)
      expect(response).to redirect_to(personal_tasks_path)
      expect(flash[:notice]).to eq(I18n.t('tasks.destroy.success'))
    end
  end
end
