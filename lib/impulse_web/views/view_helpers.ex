defmodule ImpulseWeb.ViewHelpers do
  @moduledoc """
  Shared functionality for our views
  """
  require Logger

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
end
