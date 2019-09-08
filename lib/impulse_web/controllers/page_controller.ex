defmodule ImpulseWeb.PageController do
  use ImpulseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
