defmodule Impulse.Account do
  @moduledoc "Manages user things"
  import Ecto.Query
  import Impulse, only: [get_now: 0]
  alias Ecto.UUID, as: EctoUUID
  alias Impulse.{Repo, User}

  @invite_key_expire_days 2
  @expire_minutes 60
  @secret Application.get_env(:impulse, :auth_secret)

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_name(name),
    do: Repo.one(from(u in User, where: u.name == ^name))

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(user \\ %User{}, params \\ %{}) do
    User.changeset(user, params)
  end

  def change_user_add_invite_link(user) do
    User.changeset(user, %{
      invite_key: EctoUUID.generate(),
      invite_key_issued_at: DateTime.utc_now()
    })
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}, opt \\ nil)

  def create_user(attrs, opt) do
    cs = User.changeset(%User{}, attrs)
    cs = if opt == :invite_link, do: change_user_add_invite_link(cs), else: cs

    Repo.insert(cs)
  end

  def update_user(user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  # def create(name, pass, email, admin? \\ false) do
  #   changeset =
  #     changeset(%User{}, %{
  #       "name" => name,
  #       "pwhash" => Account.hash(pass),
  #       "email" => email,
  #       "is_admin" => admin?
  #     })

  #   Impulse.Repo.insert(changeset)
  # end

  # u |> Ecto.build_assoc(:shows)
  #   |> Ecto.Changeset.cast(%{"name" => "", "slug" => ""}, req)
  #   |> Impulse.Repo.insert

  # u |> Repo.preload(:shows)
  #   |> Ecto.Changeset.cast(%{}, [])
  #   |> Ecto.Changeset.put_assoc(:shows, [s])
  #   |> Repo.update

  def generate_token(user_id, now \\ get_now(), secret \\ @secret) do
    user_id_s = user_id |> to_string
    now_s = now |> to_string
    content = user_id_s <> now_s <> secret
    hash = hash(content) |> String.slice(0..10)

    user_id_s <> "," <> now_s <> "," <> hash
  end

  def verify_token(token, now \\ get_now(), secret \\ @secret) do
    case token |> String.split(",") do
      [user_id, stamp, _hash] ->
        user_id = user_id |> Integer.parse() |> elem(0)
        stamp = stamp |> Integer.parse() |> elem(0)
        valid? = token == generate_token(user_id, stamp, secret)
        expired? = stamp_expired?(stamp, now)

        case valid? and not expired? do
          true -> user_id
          false -> false
        end

      _ ->
        false
    end
  end

  @doc """
  Hash a string, with salt.
  """
  def hash(str) when is_binary(str) do
    :sha256
    |> :crypto.hash(str <> @secret)
    |> Base.encode64()
  end

  def stamp_expired?(stamp, now) do
    (now - stamp) / 60 > @expire_minutes
  end
end
