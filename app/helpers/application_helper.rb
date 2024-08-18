module ApplicationHelper
  def sort_link(column, title)
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, class: "text-decoration-none"
  end
end
