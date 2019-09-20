defmodule Impulse.User do
  @moduledoc "User schema"
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :email, :is_admin, :shows]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :pwhash, :string
    field :is_admin, :boolean
    field :invite_key, :string
    field :invite_key_issued_at, :utc_datetime

    many_to_many :shows, Impulse.Show, join_through: "shows_users"

    timestamps()
  end

  @required_fields ~w(name email pwhash)a
  @optional_fields ~w(name email pwhash is_admin invite_key invite_key_issued_at)a

  def changeset(user, params \\ :invalid) do
    user
    |> cast(params, @optional_fields)
    # |> validate_required(@required_fields)
    |> validate_format(:name, ~r/^[a-z0-9-]{3,}$/)
    |> unique_constraint(:name)
  end

  # def create(name, pass, email, admin? \\ false) do
  #   changeset =
  #     changeset(%Impulse.User{}, %{
  #       "name" => name,
  #       "pwhash" => Impulse.Auth.hash(pass),
  #       "email" => email,
  #       "is_admin" => admin?
  #     })

  #   Impulse.Repo.insert(changeset)
  # end

  # u |> Ecto.build_assoc(:shows)
  #   |> Ecto.Changeset.cast(%{"name" => "", "slug" => ""}, req)
  #   |> Impulse.Repo.insert

  # u |> Repo.preload(:shows)
  #   |> Ecto.Changeset.cast(%{}, [])
  #   |> Ecto.Changeset.put_assoc(:shows, [s])
  #   |> Repo.update
end
