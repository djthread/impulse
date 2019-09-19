defmodule Impulse.Genre do
  use Ecto.Schema

  schema "genres" do
    field :name, :string
    many_to_many :profiles, Impulse.Profile, join_through: "genres_profiles"
  end
end
