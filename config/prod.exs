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

# Turn on SMS sending in production
config :camp_with_dennis, sms_enabled: true

# Log out to syslog
config :logger, backends: [:console, {ExSyslogger, :syslog}]
config :logger, :syslog,
  level: :debug,
  format: "[$level] $levelpad$metadata $message",
  ident: "CampWithDennis"

# Finally import any environment specific configuration
import_config "/var/apps/camp_with_dennis/*.exs"
