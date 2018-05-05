defmodule CampWithDennis.Phone.Number do
  use Ecto.Schema
  import Ecto.Changeset

  @phone_regex ~r"^\((\d{3})\) (\d{3})-(\d{4})$"
  @phone_error_message "number doesn't match the expected format (xxx) xxx-xxxx"

  @fields [
    :phone
  ]

  @primary_key false
  embedded_schema do
    field :phone, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> format_phone()
  end

  defp format_phone(changeset) do
    phone = get_field(changeset, :phone) || ""
    case Regex.run(@phone_regex, phone) do
      nil -> add_error(changeset, :phone, @phone_error_message)
      [_ | parts] ->
        put_change(changeset, :phone, "+1#{Enum.join(parts)}")
    end
  end

  def from_changeset(changeset), do: apply_changes(changeset)
end
