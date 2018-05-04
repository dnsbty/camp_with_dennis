use Mix.Config

config :camp_with_dennis, CampWithDennisWeb.Endpoint,
  url: [host: "campwithdennis.com", port: 443],
  http: [port: 2267],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Instruct OTP to start the server when creating releases
config :phoenix, :serve_endpoints, true

config :camp_with_dennis, CampWithDennisWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :camp_with_dennis, CampWithDennis.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 15

config :camp_with_dennis, message_bird_access_key: System.get_env("MESSAGE_BIRD_ACCESS_KEY")
