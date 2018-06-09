defmodule CampWithDennisWeb.PaymentsController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Invitations

  plug :get_invitation
  plug :ensure_unpaid

  def new(%{assigns: %{invitation: invitation}} = conn, _) do
    changeset = Invitations.change_accepted(invitation.accepted)
    render(conn, "new.html", changeset: changeset, invitation: invitation)
  end

  def save(%{assigns: %{invitation: invitation}} = conn, %{"accepted" => accepted}) do
    with Invitations.save_payment(invitation, accepted) do
      conn
      |> put_flash(:info, "Saved payment for #{invitation.name}")
      |> redirect(to: invitations_path(conn, :index))
    end
  end

  def get_invitation(%{params: %{"invitation_id" => id}} = conn, _) do
    invitation = Invitations.get_invitation(id)
    assign(conn, :invitation, invitation)
  end
  def get_invitation(conn, _) do
    conn
    |> put_flash(:error, "Please provide an invitation ID")
    |> redirect(to: invitations_path(conn, :index))
    |> halt()
  end

  def ensure_unpaid(%{assigns: %{invitation: %{accepted: %{paid_via: method}}}} = conn, _) do
    case method do
      "" -> conn
      _ ->
        conn
        |> put_flash(:error, "That user already paid.")
        |> redirect(to: invitations_path(conn, :index))
        |> halt()
    end
  end

  def ensure_unpaid(conn, _) do
    conn
    |> put_flash(:error, "That user hasn't yet RSVPed.")
    |> redirect(to: invitations_path(conn, :index))
    |> halt()
  end
end
