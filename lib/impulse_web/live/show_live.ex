defmodule ImpulseWeb.ShowLive do
  @moduledoc "The LiveView for a show page"
  use Phoenix.LiveView
  alias Impulse.Programmer
  alias ImpulseWeb.{HomeLive, ShowView}
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
         |> redirect(to: Routes.live_path(socket, HomeLive))}

      show ->
        {:noreply, assign(socket, :show, show)}
    end
  end
end
