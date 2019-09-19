defmodule Impulse.Repo.Migrations.DjProfiles do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :invite_key, :string
      add :invite_key_issued_at, :utc_datetime
    end

    create table(:profiles) do
      add :is_public, :boolean
      add :name, :string
      add :bio, :text

      timestamps()
    end

    create table(:genres) do
      add :name, :string
    end

    create table(:genres_profiles) do
      add :genre_id, references(:genres), null: false
      add :profile_id, references(:profiles), null: false
    end
  end
end
