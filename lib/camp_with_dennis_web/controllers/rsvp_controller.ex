defmodule CampWithDennisWeb.RsvpController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Rsvp

  def index(conn, _) do
    render(conn, "index.html")
  end

  def accept(conn, _) do
    render(conn, "accept.html")
  end

  def decline(conn, _) do
    render(conn, "decline.html")
  end

  def size(conn, size) do
    with {:ok, size} <- Rsvp.validate_size(size) do
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
