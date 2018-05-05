defmodule CampWithDennis.Phone.Code do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :code,
    :phone
  ]

  @code_format ~r"\d{6}"
  @phone_format ~r"^\+1\d{10}$"
  @code_error_message "does not match the one sent to your phone number"

  @primary_key false
  embedded_schema do
    field :code, :string
    field :phone, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_format(:code, @code_format, message: "should be 6-digits long")
    |> validate_format(:phone, @phone_format, message: "was not provided")
    |> verify_code()
  end

  def from_changeset(changeset), do: apply_changes(changeset)

  defp verify_code(%{valid?: false} = changeset), do: changeset
  defp verify_code(changeset) do
    phone = get_field(changeset, :phone)
    code = get_field(changeset, :code)

    case SmsVerification.verify(phone, code) do
      :error -> add_error(changeset, :code, @code_error_message)
      :ok -> changeset
    end
  end
end
