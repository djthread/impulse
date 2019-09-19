defmodule Impulse.Repo.Migrations.AddGenres do
  use Ecto.Migration
  alias Impulse.{Genre, Repo}

  def up do
    Repo.insert!(%Genre{name: "Drum and Bass"})
    Repo.insert!(%Genre{name: "House"})
    Repo.insert!(%Genre{name: "Techno"})
    Repo.insert!(%Genre{name: "Hardcore"})
  end
end
