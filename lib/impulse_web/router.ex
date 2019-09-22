defmodule ImpulseWeb.Router do
  use ImpulseWeb, :router
  alias ImpulseWeb.LayoutView

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {LayoutView, :normal}
  end

  pipeline :full_width do
    plug :put_layout, {LayoutView, :full_width}
  end

  scope "/", ImpulseWeb do
    pipe_through :browser

    scope "/" do
      pipe_through :full_width
      live "/", HomeLive
    end

    live "/shows", ShowsLive
    live "/shows/:slug", ShowLive
    live "/shows/:slug/:section", ShowLive
    live "/shows/:slug/:section/:page", ShowLive

    live "/create", CreateUserLive
  end
end
