defmodule CampWithDennis.Rsvp.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :paid_via
  ]

  @payment_methods ["venmo", "square_cash", "apple_pay_cash"]

  @primary_key false
  embedded_schema do
    field :paid_via, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:paid_via, @payment_methods)
  end

  def from_changeset(changeset), do: apply_changes(changeset)
end
