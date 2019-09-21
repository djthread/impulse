defmodule ImpulseWeb.HomeLive do
  @moduledoc "LiveView for the home page"
  use Phoenix.LiveView
  alias Impulse.{Programmer, Repo, Show}
  alias ImpulseWeb.HomeView

  def render(assigns) do
    HomeView.render("index.html", assigns)
  end

  def mount(_params, socket) do
    {episodes, events} = Programmer.episodes_and_events()
    {:ok, socket |> assign(episodes: episodes, events: events)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
