defmodule Impulse.Programmer do
  @moduledoc """
  Manages info about shows
  """
  import Ecto.Query
  alias Impulse.{Episode, Event, Programmer, Repo, Show}
  require Logger

  def shows do
    enabled = Application.fetch_env!(:impulse, :shows_enabled)
    Repo.all(from sh in Show, where: sh.slug in ^enabled)
  end

  def show(slug) do
    Repo.one(from sh in Show, where: sh.slug == ^slug)
  end

  def episodes(opts \\ []) do
    Repo.all(
      from ep in Episode,
        join: sh in assoc(ep, :show),
        select: {ep, sh.name, sh.slug},
        order_by: [desc: ep.record_date],
        limit: 10
    )
  end

  def events(opts \\ []) do
    from(ev in Event,
      join: sh in assoc(ev, :show),
      select: {ev, sh.name, sh.slug},
      order_by: [desc: ev.happens_on],
      limit: 10
    )
    |> query_only_show(Keyword.get(opts, :show_id))
    |> Repo.all()
    |> Enum.map(fn data ->
      event = elem(data, 0)
      info_json = Jason.decode!(event.info_json)

      data
      |> Tuple.delete_at(0)
      |> Tuple.insert_at(0, %{event | info_json: info_json})
    end)
  end

  defp query_only_show(query, nil), do: query

  defp query_only_show(query, show_id),
    do: from(q in query, where: q.show_id == ^show_id)

  # def preload_a_month_of_episodes_and_events(shows) do
  #   shows
  #   |> Repo.preload(
  #     episodes:
  #       from(ep in Episode,
  #         where: ep.record_date > ago(1, "month"),
  #         order_by: [desc: ep.number]
  #       )
  #   )
  #   |> Repo.preload(
  #     events:
  #       from(ev in Event,
  #         where:
  #           ev.happens_on > ago(2, "day") and
  #             ev.happens_on < from_now(1, "month"),
  #         order_by: ev.happens_on
  #       )
  #   )
  # end

  # def preload_episodes_and_events(show) do
  #   show
  #   |> Repo.preload(episodes: from(ep in Episode, order_by: [desc: ep.number]))
  #   |> Repo.preload(
  #     events:
  #       from(ev in Event,
  #         where: ev.happens_on > ago(2, "day"),
  #         order_by: ev.happens_on
  #       )
  #   )
  # end

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
