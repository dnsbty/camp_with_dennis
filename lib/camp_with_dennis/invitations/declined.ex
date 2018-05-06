defmodule CampWithDennis.Invitations.Declined do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Invitations.Invitation

  @primary_key false
  schema "declined" do
    belongs_to :invitation, Invitation

    timestamps()
  end

  @doc false
  def changeset(struct, invitation) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:invitation, invitation, required: true)
    |> unique_constraint(:invitation_id, name: :declined_pkey)
  end
end
