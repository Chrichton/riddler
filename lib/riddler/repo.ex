defmodule Riddler.Repo do
  use Ecto.Repo,
    otp_app: :riddler,
    adapter: Ecto.Adapters.Postgres
end
