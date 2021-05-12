# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :transactions_mono,
  ecto_repos: [TransactionsMono.Repo]

# Configures the endpoint
config :transactions_mono, TransactionsMonoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ab2reKFNwYPGeakqYhBd0gG6UMcX9zYUK5hP5pESREwcf7xsRqxk1A/y6d2zOEtP",
  render_errors: [view: TransactionsMonoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TransactionsMono.PubSub,
  live_view: [signing_salt: "h3qpeN+n"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  json_library: Jason,
  template_engines: [leex: Phoenix.LiveView.Engine]

#Config Guardian
config :transactions_mono, TransactionsMono.Guardian,
  issuer: "transactions_mono",
  secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
  ttl: {3, :days}

config :transactions_mono, TransactionsMonoWeb.AuthAccessPipeline,
  module: TransactionsMono.Guardian,
  error_handler: TransactionsMonoWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
