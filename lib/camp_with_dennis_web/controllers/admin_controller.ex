defmodule CampWithDennisWeb.AdminController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Invitations

  def index(conn, _params) do
    count = Invitations.count_invitations()
    render(conn, "index.html", count: count)
  end
end
