defmodule Impulse.Event do
  @moduledoc "Event schema"
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id]}

  schema "events" do
    field :title, :string
    field :info_json, :string
    field :happens_on, :date
    field :description, :string

    belongs_to :user, Impulse.User
    belongs_to :show, Impulse.Show

    timestamps()
  end

  @required_fields ~w(title happens_on)a
  @optional_fields ~w(title info_json happens_on description)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(event, params \\ :invalid) do
    event
    |> cast(params, @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:show)
  end
end
