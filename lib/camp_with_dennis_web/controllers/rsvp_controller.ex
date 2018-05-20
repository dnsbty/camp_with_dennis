defmodule CampWithDennisWeb.RsvpController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Rsvp
  require Logger

  def index(conn, _) do
    render(conn, "index.html")
  end

  def accept(%{assigns: %{invitation: invitation}} = conn, _) do
    with {:ok, _accepted} <- Rsvp.accept_invitation(invitation) do
      redirect(conn, to: rsvp_path(conn, :accepted))
    else
      error ->
        Logger.error("Failed to accept invite: #{inspect error}")
        conn
        |> put_flash(:error, "😕 Something went wrong. Try again?")
        |> render("index.html")
    end
  end

  def accepted(conn, _) do
    render(conn, "accept.html")
  end

  def decline(%{assigns: %{invitation: invitation}} = conn, _) do
    with {:ok, _accepted} <- Rsvp.decline_invitation(invitation) do
      redirect(conn, to: rsvp_path(conn, :declined))
    else
      _ ->
      conn
      |> put_flash(:error, "😕 Something went wrong. Try again?")
      |> render("index.html")
    end
  end

  def declined(conn, _) do
    render(conn, "declined.html")
  end

  def size(%{assigns: %{invitation: invitation}} = conn, size) do
    with {:ok, _invitation} <- Rsvp.save_size(invitation, size) do
      redirect(conn, to: rsvp_path(conn, :pay))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, changeset_errors(changeset))
        |> render(conn, "accept.html")
    end
  end

  def pay(conn, _params) do
    render(conn, "pay.html")
  end
end
