defmodule CampWithDennis.Invitations.Accepted do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Invitations.Invitation

  @primary_key false
  schema "accepted" do
    belongs_to :invitation, Invitation

    timestamps()
  end

  @doc false
  def changeset(struct, invitation) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:invitation, invitation, required: true)
    |> unique_constraint(:invitation_id, name: :accepted_pkey)
  end
end
