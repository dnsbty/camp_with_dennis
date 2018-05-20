use Mix.Config

config :camp_with_dennis, CampWithDennisWeb.Endpoint,
  url: [host: "campwithdennis.com", port: 443],
  http: [port: 2267],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Instruct OTP to start the server when creating releases
config :phoenix, :serve_endpoints, true

# Basic db configuration that can be overwritten in imported config
config :camp_with_dennis, CampWithDennis.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ressipy_prod",
  hostname: "localhost",
  pool_size: 15

# Finally import any environment specific configuration
import_config "/var/apps/camp_with_dennis/*.exs"
