defmodule CampWithDennis.Phone do
  import Ecto.Query
  alias CampWithDennis.Admin.User, as: Admin
  alias CampWithDennis.Invitations.Invitation
  alias CampWithDennis.Repo
  alias CampWithDennis.Phone.{
    Code,
    Number
  }

  def code_changeset(params \\ %{}) do
    Code.changeset(%Code{}, params)
  end

  def get_phone(number) do
    Number
    |> join(:left, [n], a in assoc(n, :admin))
    |> join(:left, [n], i in assoc(n, :invitation))
    |> preload([n, a, i], [admin: a, invitation: i])
    |> limit(1)
    |> Repo.get_by(number: number)
  end

  def list_paid_numbers do
    Number
    |> join(:inner, [n], i in assoc(n, :invitation))
    |> join(:inner, [n, i], a in assoc(i, :accepted))
    |> where([n, i, a], a.paid_via != "")
    |> select([n], n.number)
    |> Repo.all()
  end

  def number_changeset(params \\ %{}) do
    Number.changeset(%Number{}, params)
  end

  def send_to_all_paid(message) do
    paid = list_paid_numbers()
    MessageBird.send_message(paid, message)
  end

  def send_verification(params) do
    with %{valid?: true} = changeset <- number_changeset(params),
         %{number: number} = Number.from_changeset(changeset),
         {:ok, _} <- SmsVerification.send(number)
    do
      {:ok, number}
    else
      %{valid?: false} = changeset ->
        {:error, changeset}
    end
  end

  def verify(params) do
    changeset = code_changeset(params)
    with %{valid?: true} <- changeset,
         %{number: number} = Code.from_changeset(changeset),
         %Number{} = phone <- get_phone(number) do
      case phone do
        %{admin: %Admin{} = admin} ->
          {:ok, admin}
        %{invitation: %Invitation{} = invite} ->
          {:ok, invite}
      end
    else
      nil -> {:not_found, changeset}
      _ -> {:error, changeset}
    end
  end
end
