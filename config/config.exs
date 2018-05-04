# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :camp_with_dennis,
  environment: Mix.env(),
  ecto_repos: [CampWithDennis.Repo]

# Configures the endpoint
config :camp_with_dennis, CampWithDennisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bfhqJxbQ10v1TNpvwgl9puw+pf9aEKOW9cc0YTNx3DWF+Wpnh2hw2/uDt4reayEt",
  render_errors: [view: CampWithDennisWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CampWithDennis.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
