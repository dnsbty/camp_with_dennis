defmodule CampWithDennisWeb.InvitationsController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Invitations

  def new(conn, _params) do
    render(conn, "new.html", changeset: Invitations.invitation_changeset())
  end

  def create(%{assigns: %{admin: user}} = conn, %{"invitation" => invitation}) do
    attrs = Map.put(invitation, "invited_by", user)

    with {:ok, _invitation} <- Invitations.create_invitation(attrs) do
      conn
      |> put_flash(:info, "Invitation was successfully created.")
      |> redirect(to: admin_path(conn, :index))
    end
  end

  def sent(conn, %{"invitation_id" => invitation_id}) do
    with {1, nil} <- Invitations.mark_sent(invitation_id) do
      conn
      |> put_flash(:info, "Invitation was successfully marked as sent.")
      |> redirect(to: admin_path(conn, :index))
    end
  end
end
