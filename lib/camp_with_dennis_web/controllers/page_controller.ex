defmodule CampWithDennisWeb.PageController do
  use CampWithDennisWeb, :controller
  alias CampWithDennis.Phone

  def index(conn, %{"phone" => _} = params) do
    render conn, "index.html", phone: Phone.number_changeset(params)
  end

  def index(conn, _params) do
    render conn, "index.html", changeset: Phone.number_changeset()
  end
end
