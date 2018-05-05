defmodule CampWithDennis.Admin.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Phone.Number

  @attrs [
    :name
  ]

  schema "admins" do
    field :name, :string
    has_one :phone, Number, foreign_key: :admin_id

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> cast_assoc(:phone, required: true, with: &Number.changeset/2)
    |> unique_constraint(:phone, name: :admins_phone_index)
  end
end
