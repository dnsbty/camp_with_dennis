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
    Invitation
    |> join(:left, [i], a in assoc(i, :accepted))
    |> join(:left, [i], d in assoc(i, :declined))
    |> preload([i, a, d], [accepted: a, declined: d])
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Returns the list of accepted invitations.

  ## Examples

      iex> list_accepted()
      [%Invitation{}, ...]

  """
  def list_accepted do
    base = invitation_base()

    base
    |> where([i, a, d], is_nil(d.invitation_id))
    |> where([i, a, d], a.paid_via in ["venmo", "square_cash", "apple_pay_cash"])
    |> Repo.all()
  end

  @doc """
  Returns the list of pending invitations.

  ## Examples

      iex> list_pending()
      [%Invitation{}, ...]

  """
  def list_pending do
    base = invitation_base()

    base
    |> where([i, a, d], is_nil(d.invitation_id))
    |> where([i, a, d], is_nil(a.paid_via) or a.paid_via == "")
    |> Repo.all()
  end

  defp invitation_base do
    Invitation
    |> join(:left, [i], a in assoc(i, :accepted))
    |> join(:left, [i], d in assoc(i, :declined))
    |> preload([i, a, d], [accepted: a, declined: d])
    |> order_by(asc: :name)
  end

  @doc """
  Returns the list of accepted invitations.

  ## Examples

      iex> list_accepted()
      [%Invitation{}, ...]

  """
  def list_accepted do
    Invitation
    |> join(:inner, [i], a in assoc(i, :accepted))
    |> preload([i, a], [accepted: a])
    |> Repo.all()
  end

  @doc """
  Returns the list of declined invitations.

  ## Examples

      iex> list_declined()
      [%Invitation{}, ...]

  """
  def list_declined do
    Invitation
    |> join(:inner, [i], d in assoc(i, :declined))
    |> preload([i, d], [declined: d])
    |> Repo.all()
  end

  @doc """
  Count invitations.

  ## Examples

      iex> count_invitations()
      %{accepted: 1, declined: 0, total: 1}

  """
  def count_invitations do
    Invitation
    |> join(:left, [i], d in assoc(i, :declined))
    |> select([i, d], %{declined: count(d.invitation_id), total: fragment("count(1)")})
    |> limit(1)
    |> Repo.one
    |> put_accepted()
    |> put_pending()
    |> put_remaining()
  end

  def put_accepted(counts) do
    query = from a in Accepted, where: a.paid_via != "", select: count(1)
    accepted = Repo.one(query)

    Map.put(counts, :accepted, accepted)
  end

  defp put_pending(%{accepted: accepted, declined: declined, total: total} = counts) do
    Map.put(counts, :pending, total - accepted - declined)
  end

  defp put_remaining(%{accepted: accepted, pending: pending} = counts) do
    Map.put(counts, :remaining, @total_spots - accepted - pending)
  end

  @doc """
  Count the number of invitations that selected each shirt size.

  ## Examples

      iex> count_shirt_sizes()\
      %{"XS" => 1, "S" => 2, "L" => 5, "XL" => 1}
  """
  def count_shirt_sizes do
    Accepted
    |> group_by([a], a.shirt_size)
    |> select([a], {a.shirt_size, count(1)})
    |> Repo.all()
    |> Enum.into(%{})
  end

  @doc """
  Breaks down the genders of accepted and pending invitations.

  ## Examples

      iex> breakdown_genders(invitations)
      %{accepted: %{male: 1, female: 1}, pending: %{male: 0, female: 1}}

  """
  def breakdown_genders(invitations) do
    breakdown = %{
      accepted: %{male: 0, female: 0},
      pending: %{male: 0, female: 0}
    }

    Enum.reduce(invitations, breakdown, fn
      %{accepted: nil, declined: nil, gender: gender}, breakdown ->
        increment_breakdown(breakdown, :pending, gender)
      %{accepted: %Accepted{}, gender: gender}, breakdown ->
        increment_breakdown(breakdown, :accepted, gender)
      _, breakdown ->
        breakdown
    end)
  end

  defp increment_breakdown(breakdown, status, mf) do
    gender = gender(mf)
    current = breakdown[status][gender]
    put_in(breakdown, [status, gender], current + 1)
  end

  defp gender("M"), do: :male
  defp gender("F"), do: :female

  @doc """
  Mark an invitation as having been sent.

  ## Examples

      iex> mark_sent(123)
      {:ok, %Invitation{sent?: true}}

  """
  def mark_sent(invitation_id) do
    query = from i in Invitation, where: i.id == ^invitation_id
    Repo.update_all(query, set: [sent?: true])
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
  Clears all RSVPs but leaves invitations intact.

  ## Examples

      iex> clear_rsvps()
      {:ok, 1}

  """
  def clear_rsvps() do
    Repo.delete_all(Accepted)
    Repo.delete_all(Declined)
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

      iex> accepted_changeset(%{})
      %Ecto.Changeset{changes: %{}}

  """
  def accepted_changeset(params \\ %{}) do
    Accepted.changeset(%Accepted{}, params)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` more for display purposes.

  ## Examples

      iex> declined_changeset(%{})
      %Ecto.Changeset{changes: %{}}

  """
  def declined_changeset(params \\ %{}) do
    Declined.changeset(%Declined{}, params)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` more for display purposes.

  ## Examples

      iex> payment_changeset(%{})
      %Ecto.Changeset{changes: %{}}

  """
  def change_accepted(accepted, params \\ %{}) do
    Accepted.changeset(accepted, params)
  end

  def save_payment(invitation, params) do
    case change_accepted(invitation.accepted, params) do
      %{valid?: true} = changeset ->
        Repo.update(changeset)
      changeset ->
        {:error, changeset}
    end
  end
end
