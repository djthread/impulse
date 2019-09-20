defmodule ImpulseWeb.HomeLive do
  @moduledoc "LiveView for the home page"
  use Phoenix.LiveView
  alias ImpulseWeb.HomeView

  def render(assigns) do
    HomeView.render("index.html", assigns)
  end

  def mount(_params, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
