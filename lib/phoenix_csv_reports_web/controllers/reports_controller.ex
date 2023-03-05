defmodule PhoenixCsvReportsWeb.ReportsController do
  use PhoenixCsvReportsWeb, :controller

  alias PhoenixCsvReportsWeb.FallbackController
  alias PhoenixCsvReports.Pipelines.Reports.GenerateCsv

  action_fallback PhoenixCsvReportsWeb.FallbackController

  @create_params_schema %{
    report_name: [
      type: :string,
      required: true,
      in: ~w(DailyRegistrations DailyRegistrationsByPartner)
    ],
    start_date: [type: :date, default: Date.utc_today()],
    end_date: [type: :date, default: Date.utc_today()]
  }
  def create(conn, params) do
    with {:ok, %{report_name: report_name, end_date: end_date, start_date: start_date}} <-
           Tarams.cast(params, @create_params_schema) do
      render(conn, :daily_registrations,
        csvs: GenerateCsv.call(report_name, %{start_date: start_date, end_date: end_date})
      )
    else
      {:error, errors} -> FallbackController.call(conn, {:error, errors})
    end
  end
end
