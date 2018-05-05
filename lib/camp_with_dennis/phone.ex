defmodule CampWithDennis.Phone do
  alias CampWithDennis.Phone.{
    Code,
    Number
  }

  def code_changeset(params \\ %{}) do
    Code.changeset(%Code{}, params)
  end

  def number_changeset(params \\ %{}) do
    Number.changeset(%Number{}, params)
  end

  def send_verification(params) do
    with %{valid?: true} = changeset <- number_changeset(params),
         %{phone: number} = Number.from_changeset(changeset),
         {:ok, _} <- SmsVerification.send(number)
    do
      {:ok, number}
    else
      %{valid?: false} = changeset ->
        {:error, changeset}
    end
  end

  def verify(params) do
    with %{valid?: true} = changeset <- code_changeset(params) do
      {:ok, Code.from_changeset(changeset)}
    else
      changeset -> {:error, changeset}
    end
  end
end
