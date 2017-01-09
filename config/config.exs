# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :peep,
  ecto_repos: [Peep.Repo]

# Configures the endpoint
config :peep, Peep.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KvEtf+pb9huSoAtIUIDtDPWIXIAJxBuwhFwTMB7DDCppHl36FNitPZMud/ppFXwi",
  render_errors: [view: Peep.ErrorView, accepts: ~w(json)],
  pubsub: [name: Peep.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

#Json Api
config :phoenix, :format_encoders,
"json-api": Poison

config :plug, :mimes, %{
"application/vnd.api+json" => ["json-api"]
}


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
