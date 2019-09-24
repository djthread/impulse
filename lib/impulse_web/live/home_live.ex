defmodule ImpulseWeb.HomeLive do
  @moduledoc "LiveView for the home page"
  use Phoenix.LiveView
  alias Impulse.Programmer
  alias ImpulseWeb.HomeView

  def render(assigns) do
    HomeView.render("index.html", assigns)
  end

  def mount(_params, socket) do
    episodes = Programmer.episodes()
    events = Programmer.events()

    {:ok, socket |> assign(episodes: episodes, events: events)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
