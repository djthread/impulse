defmodule Impulse.Programmer do
  @moduledoc """
  Manages info about shows
  """
  import Ecto.Query
  alias Impulse.{Episode, Event, Repo}

  def preload_a_month_of_episodes_and_events(shows) do
    shows
    |> Repo.preload(
      episodes:
        from(ep in Episode,
          where: ep.record_date > ago(1, "month"),
          order_by: [desc: ep.number]
        )
    )
    |> Repo.preload(
      events:
        from(ev in Event,
          where:
            ev.happens_on > ago(2, "day") and
              ev.happens_on < from_now(1, "month"),
          order_by: ev.happens_on
        )
    )
  end

  def preload_episodes_and_events(show) do
    show
    |> Repo.preload(episodes: from(ep in Episode, order_by: [desc: ep.number]))
    |> Repo.preload(
      events:
        from(ev in Event,
          where: ev.happens_on > ago(2, "day"),
          order_by: ev.happens_on
        )
    )
  end

  # iex(16)> u |> Tuesday.User.changeset(%{}) |> Ecto.Changeset.put_assoc(:shows, [s]) |> Tuesday.Repo.update!
  #
  # def create_show(params, user_name) do
  #   import Ecto.Query
  #   user = Tuesday.User |> where(name: ^user_name) |> Tuesday.Repo.one
  #
  #   %Tuesday.Show{name: "Techno Tuesday", slug: "techno-tuesday"})
  #   |> Repo.insert!
  #   |> put_assoc
  #   # changeset(%Tuesday.Show{}, params)
  #   # |> put_assoc(:users, [user])
  #
  #   # import Ecto.Query
  #   # user = Tuesday.User |> where(name: ^user_name) |> Tuesday.Repo.one
  #   #
  #   # %Tuesday.Show{name: name, slug: slug}
  #   # |> put_assoc(:users, [user])
  #   # |> Tuesday.Repo.insert!
  # end

end
