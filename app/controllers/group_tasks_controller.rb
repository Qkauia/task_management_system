# frozen_string_literal: true

# The main application controller that other controllers inherit from.
class GroupTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    base_scope = Task.for_user_groups(current_user)

    @tasks = load_tasks(base_scope, params).sorted.page(params[:page]).per(10)

    @important_tasks = load_tasks(base_scope.important.with_shared_count, params)

    respond_to do |format|
      format.html
      format.json do
        render json: @tasks.map { |task| calendar_serialize_task(task) }
      end
    end
  end
end
