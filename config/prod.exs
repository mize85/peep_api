use Mix.Config

config :peep, Peep.Web.Endpoint,
  http: [port: {:system, "PORT"}],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  url: [host: "peaceful-journey-56522.herokuapp.com", port: 443],
  check_origin: ["https://peaceful-journey-56522.herokuapp.com", "https://pure-escarpment-53002.herokuapp.com"],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :peep, Peep.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

# Do not print debug messages in production
config :logger, level: :info
