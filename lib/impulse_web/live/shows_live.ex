defmodule ImpulseWeb.ShowsLive do
  @moduledoc "The LiveView for the shows listing"
  use Phoenix.LiveView
  # alias ImpulseWeb.{Endpoint, ShowsView}
  # alias ImpulseWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ShowsView.render("index.html", assigns)
  end

  def mount(_params, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
