defmodule PhoenixCsvReportsWeb.ReportsJSON do
  @moduledoc """
    Render the JSON response for the
  """

  def csv_report(%{csvs: csvs}) do
    %{data: csvs}
  end
end
