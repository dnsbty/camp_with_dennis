use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :camp_with_dennis, CampWithDennisWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger,
  backends: [:console],
  level: :warn

# Configure your database
config :camp_with_dennis, CampWithDennis.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "camp_with_dennis_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :camp_with_dennis, message_bird_access_key: "ACCESS_KEY"
config :honeybadger, api_key: ""

config :logger, :logger_papertrail_backend,
  url: "",
  level: :debug,
  format: "$time $metadata[$level] $message\n"
