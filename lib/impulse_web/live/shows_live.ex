defmodule ImpulseWeb.ShowsLive do
  @moduledoc "The LiveView for the shows listing"
  use Phoenix.LiveView
  alias Impulse.Programmer
  alias ImpulseWeb.ShowsView
  # alias ImpulseWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ShowsView.render("index.html", assigns)
  end

  def mount(_params, socket) do
    {:ok, assign(socket, :shows, Programmer.shows())}
  end
end
