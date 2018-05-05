# defmodule CampWithDennis.Admin.Phone do
#   use Ecto.Schema
#   import Ecto.Changeset
#
#   @phone_regex ~r"^\((\d{3})\) (\d{3})-(\d{4})$"
#   @phone_error_message "number doesn't match the expected format (xxx) xxx-xxxx"
#
#   @attrs [
#     :number
#   ]
#
#   @derive {Poison.Encoder, only: @attrs}
#
#   schema "admins" do
#     field :number, :string
#
#     timestamps()
#   end
#
#   def changeset(struct, params) do
#     struct
#     |> cast(params, @fields)
#     |> validate_required(@fields)
#     |> format_number()
#     |> unique_constraint(:number, name: :phones_number_index)
#   end
#
#   defp format_phone(changeset) do
#     phone = get_field(changeset, :number) || ""
#     case Regex.run(@phone_regex, phone) do
#       nil -> add_error(changeset, :number, @phone_error_message)
#       [_ | parts] ->
#         put_change(changeset, :number, "+1#{Enum.join(parts)}")
#     end
#   end
#
#   def from_changeset(changeset), do: apply_changes(changeset)
# end
