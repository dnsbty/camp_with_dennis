defmodule CampWithDennisWeb.AdminController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Invitations
  require IEx

  def index(conn, _params) do
    count = Invitations.count_invitations()
    invitations = Invitations.list_invitations()
    render(conn, "index.html", count: count, invitations: invitations)
  end
end
