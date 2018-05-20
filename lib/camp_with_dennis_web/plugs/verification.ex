defmodule CampWithDennisWeb.Verification do
  import Plug.Conn, only: [assign: 3, delete_session: 2, get_session: 2, halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias CampWithDennis.Admin
  alias CampWithDennis.Admin.User, as: AdminUser
  alias CampWithDennis.Invitations
  alias CampWithDennis.Invitations.{
    Accepted,
    Declined,
    Invitation
  }

  @spec ensure_admin(conn :: Plug.Conn.t, options :: list()) :: Plug.Conn.t
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

  @spec ensure_verified(conn :: Plug.Conn.t, options :: list()) :: Plug.Conn.t
  def ensure_verified(conn, _) do
    case get_session(conn, :invitation_id) do
      nil ->
        conn
        |> redirect(to: "/")
        |> halt()
      invitation_id ->
        conn
        |> assign_invitation(invitation_id)
        |> maybe_redirect_to_rsvp()
    end
  end

  @spec ensure_unverified(conn :: Plug.Conn.t, options :: list()) :: Plug.Conn.t
  def ensure_unverified(conn, _) do
    case get_session(conn, :invitation_id) do
      nil -> conn
      invitation_id ->
        conn
        |> assign_invitation(invitation_id)
        |> maybe_redirect_to_rsvp()
    end
  end

  @spec assign_admin_to_conn(conn :: Plug.Conn.t, admin_id :: integer()) :: Plug.Conn.t
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

  @spec assign_invitation(conn :: Plug.Conn.t, invitation_id :: integer()) :: Plug.Conn.t
  defp assign_invitation(conn, invitation_id) do
    with %Invitation{} = invitation <- Invitations.get_invitation(invitation_id) do
      assign(conn, :invitation, invitation)
    else
      nil ->
        conn
        |> delete_session(:invitation_id)
        |> put_flash(:error, "Uh oh! We can't find your invitation. Please try again.")
        |> redirect(to: "/logout")
        |> halt()
    end
  end

  @spec maybe_redirect_to_rsvp(conn :: Plug.Conn.t) :: Plug.Conn.t
  defp maybe_redirect_to_rsvp(%{assigns: %{invitation: invitation}, method: "GET"} = conn) do
    expected = expected_path(invitation)
    case conn.request_path do
      ^expected -> conn
      _ ->
        conn
        |> redirect(to: expected)
        |> halt()
    end
  end
  defp maybe_redirect_to_rsvp(conn), do: conn

  @spec expected_path(invitation :: map()) :: atom()
  defp expected_path(%{accepted: nil, declined: nil}), do: "/rsvp"
  defp expected_path(%{declined: %Declined{}}), do: "/rsvp/declined"
  defp expected_path(%{accepted: %Accepted{shirt_size: ""}}), do: "/rsvp/accepted"
  defp expected_path(%{accepted: %Accepted{}}), do: "/rsvp/pay"
end
