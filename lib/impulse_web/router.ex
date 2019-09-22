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
  end

  scope "/", ImpulseWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/shows", ShowsLive
    live "/shows/:slug", ShowLive
    live "/shows/:slug/:section", ShowLive
    live "/shows/:slug/:section/:page", ShowLive

    live "/create", CreateUserLive
  end
end
