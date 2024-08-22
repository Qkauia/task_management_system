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

    respond_to do |format|
      format.html
      format.json do
        render json: @tasks.map { |task|
          {
            id: task.id,
            title: task.title,
            start: task.start_time,
            end: task.end_time,
            url: task_path(task),
            color: case task.status
                   when 'pending' then '#808080'
                   when 'in_progress' then '#728C72'
                   when 'completed' then '#A2634C'
                   else '#000000'
                   end
          }
        }
      end
    end
  end
end
