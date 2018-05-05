defmodule CampWithDennis.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :name, :string, default: "", null: false
      add :invited_by_id, references(:admins, on_delete: :nothing), null: false

      timestamps()
    end

    alter table(:phones) do
      add :invitation_id, references(:invitations)
    end

    create index(:invitations, [:invited_by_id])
    create index(:phones, [:invitation_id])
  end
end
