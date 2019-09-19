import Config

config :impulse, :auth_secret, System.fetch.env!("AUTH_SECRET")
