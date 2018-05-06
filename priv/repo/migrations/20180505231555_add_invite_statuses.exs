defmodule CampWithDennis.Repo.Migrations.AddInviteStatuses do
  use Ecto.Migration

  def change do
    create table(:accepted, primary_key: false) do
      add :invitation_id, references(:invitations, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create table(:declined, primary_key: false) do
      add :invitation_id, references(:invitations, on_delete: :delete_all), primary_key: true

      timestamps()
    end
  end
end
