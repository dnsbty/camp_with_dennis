defmodule CampWithDennis.Phone do
  import Ecto.Query
  alias CampWithDennis.Admin.User, as: Admin
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
    |> preload([n, a], [admin: a])
    |> limit(1)
    |> Repo.get_by(number: number)
  end

  def number_changeset(params \\ %{}) do
    Number.changeset(%Number{}, params)
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
    with %{valid?: true} = changeset <- code_changeset(params),
         %{number: number} = Code.from_changeset(changeset),
         %Number{} = phone <- get_phone(number) do
      case phone do
        %{admin: %Admin{} = admin} ->
          {:ok, admin}
        _ ->
          {:ok, phone}
      end
    else
      nil -> {:error, :number_not_found}
      changeset -> {:error, changeset}
    end
  end
end
