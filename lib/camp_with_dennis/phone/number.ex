defmodule CampWithDennis.Phone.Number do
  use Ecto.Schema
  import Ecto.Changeset
  alias CampWithDennis.Admin.User, as: Admin

  @phone_regex ~r"^\((\d{3})\) (\d{3})-(\d{4})$"
  @phone_error_message "number doesn't match the expected format (xxx) xxx-xxxx"

  @attrs [
    :number
  ]

  @derive {Poison.Encoder, only: @attrs}

  schema "phones" do
    field :number, :string

    belongs_to :admin, Admin

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @attrs)
    |> validate_required(@attrs)
    |> format_phone()
    |> unique_constraint(:number, name: :phones_number_index)
    |> IO.inspect
  end

  defp format_phone(changeset) do
    number = get_field(changeset, :number) || ""
    case Regex.run(@phone_regex, number) do
      nil -> add_error(changeset, :number, @phone_error_message)
      [_ | parts] ->
        put_change(changeset, :number, "+1#{Enum.join(parts)}")
    end
  end

  def from_changeset(changeset), do: apply_changes(changeset)
end
