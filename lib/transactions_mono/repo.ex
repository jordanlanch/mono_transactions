defmodule TransactionsMono.Repo do
  use Ecto.Repo,
    otp_app: :transactions_mono,
    adapter: Ecto.Adapters.Postgres
end
