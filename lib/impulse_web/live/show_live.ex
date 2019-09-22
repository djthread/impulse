defmodule ImpulseWeb.ShowLive do
  @moduledoc "The LiveView for a show page"
  use Phoenix.LiveView
  alias Impulse.Programmer
  alias ImpulseWeb.ShowView
  # alias ImpulseWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ShowView.render("index.html", assigns)
  end

  def mount(%{path_params: %{"slug" => slug}}, socket) do
    case Programmer.show(slug) do
      nil ->
        {:stop,
         socket
         |> put_flash(:error, "That show does not exist!")
         |> redirect(to: Routes.live_path(socket, HomeLive))}

      show ->
        {:ok, assign(socket, :show, show)}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
