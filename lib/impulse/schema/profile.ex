defmodule Impulse.Profile do
  @moduledoc "Profile schema"
  use Ecto.Schema
  import Ecto.Changeset
  alias Impulse.{Account, User}

  # @derive {Jason.Encoder, only: [:id, :name, :email, :is_admin, :shows]}

  schema "profiles" do
    field :is_public, :boolean
    field :name, :string

    many_to_many :genres, Impulse.Genre, join_through: "genres_profiles"

    timestamps()
  end

  @required_fields ~w(name email pwhash)a
  @optional_fields ~w(name email pwhash is_admin)a

  def changeset(user, params \\ :invalid) do
    user
    |> cast(params, @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
