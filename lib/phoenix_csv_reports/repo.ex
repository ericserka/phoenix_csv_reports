defmodule PhoenixCsvReports.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_csv_reports,
    adapter: Ecto.Adapters.Postgres
end
