defmodule CampWithDennis.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Admin.User, as: Admin
  alias CampWithDennis.Invitations.{
    Accepted,
    Declined
  }
  alias CampWithDennis.Phone.Number

  @fields [:name, :gender, :sent?]
  @required_fields @fields -- [:sent?]

  schema "invitations" do
    field :name, :string
    field :gender, :string
    field :sent?, :boolean

    belongs_to :invited_by, Admin
    has_one :phone, Number
    has_one :accepted, Accepted
    has_one :declined, Declined

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:gender, is: 1)
    |> put_assoc(:invited_by, attrs["invited_by"])
    |> cast_assoc(:phone, required: true, with: &Number.changeset/2)
  end
end
