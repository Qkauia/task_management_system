class ReportsController < ApplicationController
  def tag_usage
    @tag_usage = Tag.joins(:task_tags)
                    .group('tags.name')
                    .count

    respond_to do |format|
      format.html
      format.json { render json: @tag_usage }
    end
  end
end
