defmodule CampWithDennisWeb.Verification do
  import Plug.Conn, only: [assign: 3, get_session: 2, halt: 1]
  import Phoenix.Controller, only: [redirect: 2]

  def ensure_verified(conn, _) do
    case get_session(conn, :invitation_id) do
      nil ->
        conn
        |> redirect(to: "/")
        |> halt()
      invitation_id ->
        assign(conn, :invitation_id, invitation_id)
    end
  end

  def ensure_unverified(conn, _) do
    case get_session(conn, :invitation_id) do
      nil -> conn
      invitation_id ->
        conn
        |> redirect(to: "/rsvp")
        |> halt()
    end
  end
end
