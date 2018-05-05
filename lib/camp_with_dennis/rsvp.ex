defmodule CampWithDennis.Rsvp do
  alias CampWithDennis.Rsvp.Size

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
