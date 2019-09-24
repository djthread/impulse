defmodule ImpulseWeb.ShowLive do
  @moduledoc "The LiveView for a show page"
  use Phoenix.LiveView
  alias Impulse.Programmer
  alias ImpulseWeb.{Endpoint, HomeLive, ShowLive, ShowView}
  alias ImpulseWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ShowView.render("index.html", assigns)
  end

  def mount(_params, socket) do
    {:ok, socket}
  end

  def handle_params(%{"slug" => slug} = path_params, _uri, socket) do
    case Programmer.show(slug) do
      nil ->
        {:stop,
         socket
         |> put_flash(:error, "That show does not exist!")
         |> live_redirect(to: Routes.live_path(socket, HomeLive))}

      show ->
        sections = sections(show.slug)

        cond do
          Enum.any?(sections, fn {n, _, _} -> n == path_params["section"] end) ->
            {:noreply,
             assign(socket, get_assigns(path_params["section"], show, sections))}

          path_params["section"] ->
            {:stop,
             socket
             |> put_flash(:error, "No such section!")
             |> live_redirect(to: Routes.live_path(socket, ShowLive, show.slug))}

          true ->
            {:noreply, assign(socket, get_assigns("home", show, sections))}
        end
    end
  end

  defp sections(slug) do
    [
      {"home", "Home", Routes.live_path(Endpoint, ShowLive, slug)},
      {"episodes", "Episodes",
       Routes.live_path(Endpoint, ShowLive, slug, "episodes")},
      {"events", "Events",
       Routes.live_path(Endpoint, ShowLive, slug, "events")},
      {"info", "Info", Routes.live_path(Endpoint, ShowLive, slug, "info")}
    ]
  end

  defp get_assigns("home", show, sections) do
    [
      show: show,
      section: "home",
      sections: sections,
      events: Programmer.events(show_id: show.id),
      episodes: Programmer.episodes(show_id: show.id),
    ]
  end
end
