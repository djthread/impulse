defmodule Impulse.Show do
  @moduledoc "Show schema"
  use Ecto.Schema
  alias Impulse.{Episode, Event, Repo}
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :name, :slug, :hosted_by, :tiny_info, :short_info]}

  schema "shows" do
    field :name, :string
    field :slug, :string
    field :hosted_by, :string
    field :recurring_note, :string
    field :tiny_info, :string
    field :short_info, :string
    field :full_info, :string
    field :genre, :string
    field :podcast_name, :string

    has_many :events, Event
    has_many :episodes, Episode

    many_to_many :users, Impulse.User, join_through: "shows_users"

    timestamps()
  end

  @required_fields ~w(name slug)a
  @optional_fields ~w(name slug  hosted_by     recurring_note
                      tiny_info  short_info    full_info
                      genre      podcast_name  )a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(show, params \\ :invalid) do
    show
    |> cast(params, @optional_fields)
    |> validate_required(@required_fields)
  end

  def info_changeset(show, params \\ :invalid) do
    show
    |> cast(
      params,
      ~w(hosted_by recurring_note tiny_info short_info full_info)a
    )
    |> validate_required(~w(tiny_info short_info)a)
  end
end
