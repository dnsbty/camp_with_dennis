defmodule CampWithDennis.Rsvp do
  alias CampWithDennis.Rsvp.Size
  alias CampWithDennis.Invitations.Accepted
  alias CampWithDennis.{
    Invitations,
    Repo
  }

  def accept_invitation(invitation) do
    %{}
    |> Map.put(:invitation, invitation)
    |> Invitations.accepted_changeset()
    |> Repo.insert()
  end

  def decline_invitation(invitation) do
    invitation
    |> Invitations.declined_changeset()
    |> Repo.insert()
  end

  def save_size(%{accepted: accepted}, params) do
    with {:ok, size} <- validate_size(params) do
      accepted
      |> Accepted.changeset(%{shirt_size: size})
      |> Repo.update()
    end
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
