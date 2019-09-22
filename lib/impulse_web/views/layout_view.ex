defmodule ImpulseWeb.LayoutView do
  use ImpulseWeb, :view

  @doc "Render our outer-most wrapping (between the header & footer)"
  def render_layout(outer_layout, assigns, do: content) do
    render(outer_layout, Map.put(assigns, :content, content))
  end
end
