defmodule CampWithDennis.Rsvp.Size do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :size
  ]

  @possible_sizes ["XS", "S", "M", "L", "XL", "2XL", "Other"]

  @primary_key false
  embedded_schema do
    field :size, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:size, @possible_sizes)
  end

  def from_changeset(changeset), do: apply_changes(changeset)
end
