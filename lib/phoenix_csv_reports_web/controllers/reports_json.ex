defmodule PhoenixCsvReportsWeb.ReportsJSON do
  def daily_registrations(%{csv: csv}) do
    %{data: csv}
  end

  def daily_registrations_by_partner(%{csvs: csvs}) do
    %{data: csvs}
  end
end
