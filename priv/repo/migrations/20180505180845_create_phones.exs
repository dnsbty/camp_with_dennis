defmodule CampWithDennis.Repo.Migrations.AddAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string, size: 40

      timestamps()
    end

    create table(:phones) do
      add :number, :string, size: 12
      add :admin_id, references(:admins)

      timestamps()
    end

    create unique_index(:phones, :number)
    create index(:phones, :admin_id)
  end
end
