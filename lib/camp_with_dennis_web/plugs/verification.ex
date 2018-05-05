defmodule CampWithDennisWeb.Verification do
  import Plug.Conn, only: [assign: 3, delete_session: 2, get_session: 2, halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias CampWithDennis.Admin
  alias CampWithDennis.Admin.User, as: AdminUser

  def ensure_admin(conn, _) do
    case get_session(conn, :admin_id) do
      nil ->
        conn
        |> redirect(to: "/")
        |> halt()
      admin_id ->
        assign_admin_to_conn(conn, admin_id)
    end
  end

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
      _invitation_id ->
        conn
        |> redirect(to: "/rsvp")
        |> halt()
    end
  end

  defp assign_admin_to_conn(conn, admin_id) do
    with %AdminUser{} = admin <- Admin.find(admin_id) do
      assign(conn, :admin, admin)
    else
      nil ->
        conn
        |> delete_session(:admin_id)
        |> put_flash(:error, "Your admin privileges have been revoked")
        |> redirect(to: "/")
        |> halt()
    end
  end
end
