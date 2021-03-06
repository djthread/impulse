defmodule Impulse do
  @moduledoc """
  Impulse keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Timex.Timezone

  @timezone "America/Detroit"
  # @secret :tuesday
  #         |> Application.get_env(Tuesday.Web.Endpoint)
  #         |> Keyword.get(:auth_secret)

  # @doc "Get the dir of episode mp3s, given a slug"
  # def podcast_path_by_slug(slug, filename \\ nil) do
  #   # "/srv/http/impulse/impulse-app/download/" <> slug
  #   path =
  #     :tuesday
  #     |> Application.get_env(:podcast_paths)
  #     |> Map.get(slug)

  #   case filename do
  #     nil -> path
  #     file -> Path.join(path, file)
  #   end

  #   # case slug do
  #   #   "techno-tuesday" -> "/srv/http/threadbox/dnbcast"
  #   # end
  # end

  def get_now do
    DateTime.utc_now() |> DateTime.to_unix()
    # DateTime.now_utc |> DateTime.Format.unix
  end

  def display_datetime(datetime) do
    datetime
    |> Timezone.convert(@timezone)
    |> Timex.format!("%Y-%m-%d at %I:%m %P", :strftime)
  end

  # @doc "Hash a string, with salt."
  # def hash(str) when is_binary(str) do
  #   :crypto.hash(:sha256, str <> @secret)
  #   |> Base.encode64()
  # end

  # def fake_socket(topic) do
  #   %Phoenix.Socket{
  #     # pid:       self,
  #     # router:    Tuesday.Router,
  #     topic: topic,
  #     assigns: [],
  #     transport: Phoenix.Transports.WebSocket
  #   }
  # end

  # def update_podcast_feed(show) do
  #   Tuesday.ShowView
  #   |> Phoenix.View.render("feed.xml", show: show)
  #   |> IO.inspect()
  # end

  # # def bytes_by_slug_and_filename(episode) do
  # #   episode.show.slug
  # #   |> podcast_path_by_slug
  # #   |> Path.join(episode.filename)
  # #   |> File.stat
  # #   |> case do
  # #     {:ok, %File.Stat{size: size}} -> size
  # #     _                             -> nil
  # #   end
  # # end
end
