defmodule CampWithDennisWeb.AdminController do
  use CampWithDennisWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
