defmodule CampWithDennisWeb.AdminView do
  use CampWithDennisWeb, :view

  def breakdown_text(%{male: male, female: female}) do
    "#{male} male, #{female} female"
  end

  def gender(%{gender: "M"}), do: "male"
  def gender(%{gender: "F"}), do: "female"

  def open_breakdown(%{accepted: accepted, pending: pending}) do
    male = 25 - accepted.male - pending.male
    female = 25 - accepted.female - pending.female

    breakdown_text(%{male: male, female: female})
  end

  def paid(_conn, %{accepted: %{paid_via: method}}) when byte_size(method) > 0, do: "✔️"
  def paid(conn, %{id: id, accepted: %{paid_via: _}}) do
    link("❌", to: payments_path(conn, :new, id))
  end
  def paid(_, _), do: ""

  def rsvp_status(%{accepted: nil, declined: nil}), do: ""
  def rsvp_status(%{accepted: _, declined: nil}), do: "✔️"
  def rsvp_status(%{accepted: nil, declined: _}), do: "❌"

  def sent(_invitation), do: ""

  def shirt_size(%{accepted: %{shirt_size: size}}), do: size
  def shirt_size(_), do: ""
end
