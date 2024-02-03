defmodule GameDashboard.Repo do
  use Ecto.Repo,
    otp_app: :game_dashboard,
    adapter: Ecto.Adapters.Postgres
end
