class GroupTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.for_user_groups(current_user)
                 .filtered_by_status(params[:status])
                 .filtered_by_query(params[:query])
                 .filter_by_tag(params[:tag_id])
                 .order("#{sort_column} #{sort_direction}")
                 .sorted
                 .page(params[:page])
                 .per(10)

    @important_tasks = Task.for_user_groups(current_user)
                           .important
                           .with_shared_count
                           .filtered_by_status(params[:status])
                           .filtered_by_query(params[:query])
                           .filter_by_tag(params[:tag_id])
                           .order("#{sort_column} #{sort_direction}")

    respond_to do |format|
      format.html
      format.json do
        render json: @tasks.map { |task| calendar_serialize_task(task) }
      end
    end
  end
end
