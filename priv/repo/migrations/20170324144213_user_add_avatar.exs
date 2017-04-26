defmodule Peep.Repo.Migrations.UserAddAvatar do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :avatar, :string
    end
  end
end
