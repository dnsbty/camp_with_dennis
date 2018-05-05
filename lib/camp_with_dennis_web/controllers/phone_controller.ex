defmodule CampWithDennisWeb.PhoneController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Phone
  alias CampWithDennis.Admin.User, as: Admin

  def index(conn, _params) do
    render conn, "index.html", changeset: Phone.number_changeset()
  end

  def code(conn, %{"number" => number}) do
    with {:ok, number} <- Phone.send_verification(number) do
      changeset = Phone.code_changeset(%{number: number})
      render(conn, "code.html", changeset: changeset)
    else
      {:error, %{valid?: false} = changeset} ->
        conn
        |> put_flash(:error, "Phone number is invalid")
        |> render("index.html", changeset: changeset)
    end
  end

  def verify(conn, %{"code" => code}) do
    with {:ok, admin_or_invitation} <- Phone.verify(code) |> IO.inspect(label: "verification") do
      handle_user(conn, admin_or_invitation)
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Code is incorrect")
        |> render("code.html", changeset: changeset)
    end
  end

  defp handle_user(conn, %Admin{id: id}) do
    conn
    |> put_session(:is_admin?, true)
    |> put_session(:admin_id, id)
    |> redirect(to: admin_path(conn, :index))
  end

  defp handle_user(conn, invitation_id) do
    conn
    |> put_session(:invitation_id, invitation_id)
    |> redirect(to: rsvp_path(conn, :index))
  end
end
