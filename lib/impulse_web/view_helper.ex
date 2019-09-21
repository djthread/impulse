defmodule ImpulseWeb.ViewHelper do
  @moduledoc """
  Shared functionality for our views
  """
  import Phoenix.HTML
  require Logger

  @doc "Create a font-awesome icon by name"
  def fas(name, class \\ nil), do: fa("fas", name, class)

  def fab(name, class \\ nil), do: fa("fab", name, class)

  def markdown(md_str) do
    case Earmark.as_html(md_str) do
      {:ok, html_str, []} ->
        html_str

      {:ok, html_str, deprecation_msgs} ->
        Logger.warn(fn ->
          """
          Deprecation warnings when rendering [#{md_str}]: \
          #{Enum.join(deprecation_msgs, ", ")}\
          """
        end)

        html_str

      {:error, html_str, error_msgs} ->
        Logger.warn(fn ->
          "Errors when rendering [#{md_str}]: #{Enum.join(error_msgs, ", ")}"
        end)

        html_str
    end
  end

  def date_format(stamp) do
    {:ok, str} = Timex.format(stamp, "%A, %B %d", :strftime)
    str
  end

  defp fa(family, name, class) do
    extra = if is_nil(class), do: [], else: [class]
    full_class = Enum.join(["icon"] ++ extra, " ")

    raw("""
    <span class="#{full_class}">
      <i class="#{family} fa-#{name}"></i>
    </span>
    """)
  end
end
