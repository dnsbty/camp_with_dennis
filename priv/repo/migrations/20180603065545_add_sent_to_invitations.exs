defmodule CampWithDennis.Repo.Migrations.AddSentToInvitations do
  use Ecto.Migration

  def change do
    alter table(:invitations) do
      add :sent?, :boolean, default: false, null: false
    end
  end
end
