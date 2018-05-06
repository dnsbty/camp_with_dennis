defmodule CampWithDennis.Rsvp do
  alias CampWithDennis.Rsvp.Size
  alias CampWithDennis.{
    Invitations,
    Repo
  }

  def accept_invitation(invitation) do
    invitation
    |> Invitations.accepted_changeset()
    |> Repo.insert()
  end

  def decline_invitation(invitation) do
    invitation
    |> Invitations.declined_changeset()
    |> Repo.insert()
  end

  def size_changeset(params \\ %{}) do
    Size.changeset(%Size{}, params)
  end

  def validate_size(params) do
    changeset = size_changeset(params)
    case changeset.valid? do
      true ->
        size =
          changeset
          |> Size.from_changeset
          |> Map.get(:size)

        {:ok, size}
      false -> {:error, changeset}
    end
  end
end
