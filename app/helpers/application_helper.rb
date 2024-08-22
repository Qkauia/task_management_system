module ApplicationHelper
  def sort_link(column, title)
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    active_class = column == params[:sort] ? "active" : ""

    link_to request.params.merge(sort: column, direction: direction), class: "text-decoration-none #{active_class}" do
      content_tag(:span, title) + tag.i(class: "icon-class")
    end
  end
end
