defmodule CampWithDennisWeb.AdminController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Invitations

  def index(conn, _params) do
    invitations = Invitations.list_invitations()
    data = [
      count: Invitations.count_invitations(),
      invitations: invitations,
      gender_breakdown: Invitations.breakdown_genders(invitations)
    ]

    render(conn, "index.html", data)
  end
end
