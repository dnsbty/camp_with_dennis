defmodule CampWithDennis.Invitations.Accepted do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Invitations.Invitation

  @fields [:paid_at, :paid_via, :shirt_size]
  @sizes ["XS", "S", "M", "L", "XL", "2XL", "Other"]
  @payment_methods ["venmo", "square_cash", "apple_pay_cash"]

  @primary_key false
  schema "accepted" do
    field :shirt_size, :string
    field :paid_at, :naive_datetime
    field :paid_via, :string

    belongs_to :invitation, Invitation, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_inclusion(:shirt_size, @sizes)
    |> validate_inclusion(:paid_via, @payment_methods)
    |> put_invitation(params)
  end

  defp put_invitation(changeset, %{invitation: invitation}) do
    changeset
    |> put_assoc(:invitation, invitation, required: true)
    |> unique_constraint(:invitation_id, name: :accepted_pkey)
  end
  defp put_invitation(changeset, _), do: changeset
end
