defmodule CampWithDennis.Invitations do
  @moduledoc """
  The Invitations context.
  """

  import Ecto.Query, warn: false
  alias CampWithDennis.Repo

  alias CampWithDennis.Invitations.{
    Accepted,
    Declined,
    Invitation
  }

  @total_spots 50

  @doc """
  Returns the list of invitations.

  ## Examples

      iex> list_invitations()
      [%Invitation{}, ...]

  """
  def list_invitations do
    Repo.all(Invitation)
  end

  @doc """
  Count invitations.

  ## Examples

      iex> count_invitations()
      %{accepted: 1, declined: 0, total: 1}

  """
  def count_invitations do
    Invitation
    |> join(:left, [i], a in assoc(i, :accepted))
    |> join(:left, [i], d in assoc(i, :declined))
    |> select([i, a, d], %{accepted: count(a.invitation_id), declined: count(d.invitation_id), total: fragment("count(1)")})
    |> limit(1)
    |> Repo.one
    |> put_pending()
    |> put_remaining()
  end

  defp put_pending(%{accepted: accepted, declined: declined, total: total} = counts) do
    Map.put(counts, :pending, total - accepted - declined)
  end

  defp put_remaining(%{accepted: accepted, pending: pending} = counts) do
    Map.put(counts, :remaining, @total_spots - accepted - pending)
  end

  @doc """
  Gets a single invitation.

  Raises `Ecto.NoResultsError` if the Invitation does not exist.

  ## Examples

      iex> get_invitation!(123)
      %Invitation{}

      iex> get_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invitation!(id), do: Repo.get!(invitation_query(), id)

  @doc """
  Gets a single invitation.

  ## Examples

      iex> get_invitation!(123)
      {:ok, %Invitation{}}

      iex> get_invitation(456)
      {:error, %Ecto.NoResultsError{}}

  """
  def get_invitation(id), do: Repo.get(invitation_query(), id)

  defp invitation_query do
    Invitation
    |> join(:left, [i], a in assoc(i, :accepted))
    |> join(:left, [i], d in assoc(i, :declined))
    |> preload([n, a, d], [accepted: a, declined: d])
    |> limit(1)
  end

  @doc """
  Creates a invitation.

  ## Examples

      iex> create_invitation(%{field: value})
      {:ok, %Invitation{}}

      iex> create_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invitation(attrs \\ %{}) do
    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invitation.

  ## Examples

      iex> update_invitation(invitation, %{field: new_value})
      {:ok, %Invitation{}}

      iex> update_invitation(invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invitation(%Invitation{} = invitation, attrs) do
    invitation
    |> Invitation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Invitation.

  ## Examples

      iex> delete_invitation(invitation)
      {:ok, %Invitation{}}

      iex> delete_invitation(invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invitation changes.

  ## Examples

      iex> change_invitation(invitation)
      %Ecto.Changeset{source: %Invitation{}}

  """
  def change_invitation(%Invitation{} = invitation) do
    Invitation.changeset(invitation, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` more for display purposes.

  ## Examples

      iex> invitation_changeset(%{some: "params"})
      %Ecto.Changeset{changes: %{some: "params"}}

  """
  def invitation_changeset(params \\ %{}) do
    Invitation.changeset(%Invitation{}, params)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` more for display purposes.

  ## Examples

      iex> accepted_changeset(%Invitation{})
      %Ecto.Changeset{changes: %{invitation: %Invitation{}}}

  """
  def accepted_changeset(invitation \\ %{}) do
    Accepted.changeset(%Accepted{}, invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` more for display purposes.

  ## Examples

      iex> accepted_changeset(%Invitation{})
      %Ecto.Changeset{changes: %{invitation: %Invitation{}}}

  """
  def declined_changeset(invitation \\ %{}) do
    Declined.changeset(%Declined{}, invitation)
  end
end
