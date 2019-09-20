defmodule ImpulseWeb.CreateUserLive do
  @moduledoc """
  LiveView for the create user screen

  This screen will be used by admins to create invite links
  """
  use Phoenix.LiveView
  alias ImpulseWeb.{Endpoint, UserView}
  alias Impulse.{Account, User}

  def render(assigns) do
    UserView.render("create.html", assigns)
  end

  def mount(_params, socket) do
    socket = assign(socket, changeset: Account.change_user(%User{}))
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Account.change_user(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Account.create_user(user_params, :invite_link) do
      {:ok, user} ->
        {:noreply,
         assign(socket,
           changeset: Account.change_user(),
           feedback: feedback(user, :created)
         )}

      {:error, %Ecto.Changeset{errors: errors} = changeset} ->
        case Keyword.get(errors, :name) do
          {_, [constraint: :unique, constraint_name: "users_name_index"]} ->
            {:ok, user} =
              user_params["name"]
              |> Account.get_user_by_name()
              |> Account.change_user_add_invite_link()
              |> Account.update_user()

            {:noreply,
             assign(socket,
               changeset: Account.change_user(),
               feedback: feedback(user, :preexisting)
             )}

          _ ->
            {:noreply, assign(socket, changeset: changeset)}
        end
    end
  end

  defp feedback(user, case_identifier) do
    link =
      Endpoint.url()
      |> URI.parse()
      |> URI.merge(%URI{path: "start/#{user.invite_key}"})
      |> to_string()

    {case_identifier, link, user}
  end
end
