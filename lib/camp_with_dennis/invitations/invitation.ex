defmodule CampWithDennis.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Admin.User, as: Admin
  alias CampWithDennis.Phone.Number

  @fields [:name]

  schema "invitations" do
    field :name, :string

    belongs_to :invited_by, Admin
    has_one :phone, Number

    timestamps()
  end

  @doc false
  def changeset(invitation, %{attrs: attrs, invited_by: invited_by}) do
    invitation
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> put_assoc(:invited_by, invited_by)
    |> cast_assoc(:phone, required: true, with: &Number.changeset/2)
  end
end
