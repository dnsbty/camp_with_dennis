defmodule CampWithDennisWeb.LayoutView do
  use CampWithDennisWeb, :view

  def title(:accepted), do: "Accepted"
  def title(:declined), do: "Declined"
  def title(:index), do: "Pending"
  def title(_), do: "Admin"

  def page_class(nil), do: ""
  def page_class(page_name), do: "page-#{page_name}"
end
