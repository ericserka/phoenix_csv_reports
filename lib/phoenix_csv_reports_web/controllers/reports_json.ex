defmodule PhoenixCsvReportsWeb.ReportsJSON do
  def daily_registrations(%{csvs: csvs}) do
    %{data: csvs}
  end

  def daily_registrations_by_partner(%{csvs: csvs}) do
    %{data: csvs}
  end
end
