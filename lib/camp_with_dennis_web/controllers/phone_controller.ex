defmodule CampWithDennisWeb.PhoneController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Phone

  def index(conn, _params) do
    render conn, "index.html", changeset: Phone.number_changeset()
  end

  def code(conn, %{"number" => number}) do
    with {:ok, number} <- Phone.send_verification(number) do
      changeset = Phone.code_changeset(%{phone: number})
      render(conn, "code.html", changeset: changeset)
    else
      {:error, %{valid?: false} = changeset} ->
        conn
        |> put_flash(:error, "Phone number is invalid")
        |> render("index.html", changeset: changeset)
    end
  end

  def verify(conn, %{"code" => code}) do
    with {:ok, invitation_id} <- Phone.verify(code) do
      conn
      |> put_session(:invitation_id, invitation_id)
      |> redirect(to: rsvp_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Code is incorrect")
        |> render("code.html", changeset: changeset)
    end
  end
end
