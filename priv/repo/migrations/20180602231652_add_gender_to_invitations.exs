defmodule CampWithDennis.Repo.Migrations.AddGenderToInvitations do
  use Ecto.Migration

  def change do
    alter table(:invitations) do
      add :gender, :char, size: 1, null: false, default: "M"
    end
  end
end
