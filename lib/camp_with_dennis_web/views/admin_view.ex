defmodule CampWithDennisWeb.AdminView do
  use CampWithDennisWeb, :view

  def paid(_conn, %{accepted: %{paid_via: method}}) when byte_size(method) > 0, do: "✔️"
  def paid(conn, %{id: id} = invitation) do
    IO.inspect(invitation)
    link("❌", to: payments_path(conn, :new, id))
  end

  def rsvp_status(%{accepted: nil, declined: nil}), do: ""
  def rsvp_status(%{accepted: _, declined: nil}), do: "✔️"
  def rsvp_status(%{accepted: nil, declined: _}), do: "❌"

  def sent(_invitation), do: ""

  def shirt_size(%{accepted: %{shirt_size: size}}), do: size
  def shirt_size(_), do: ""
end
