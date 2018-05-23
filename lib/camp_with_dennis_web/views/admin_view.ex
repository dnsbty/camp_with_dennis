defmodule CampWithDennisWeb.AdminView do
  use CampWithDennisWeb, :view

  def paid(%{accepted: %{paid_via: method}}) when length(method) > 0, do: "✔️"
  def paid(_), do: ""

  def rsvp_status(%{accepted: nil, declined: nil}), do: ""
  def rsvp_status(%{accepted: _, declined: nil}), do: "✔️"
  def rsvp_status(%{accepted: nil, declined: _}), do: "❌"

  def sent(_invitation), do: ""

  def shirt_size(%{accepted: %{shirt_size: size}}), do: size
  def shirt_size(_), do: ""
end
