defmodule CampWithDennis.Repo.Migrations.AddShirtSizeToAccepted do
  use Ecto.Migration

  def change do
    alter table(:accepted) do
      add :shirt_size, :string, default: "", null: false
      add :paid_at, :naive_datetime, default: "epoch", null: false
      add :paid_via, :string, default: "", null: false
    end
  end
end
