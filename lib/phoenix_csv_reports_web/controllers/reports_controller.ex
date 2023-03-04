defmodule PhoenixCsvReportsWeb.ReportsController do
  use PhoenixCsvReportsWeb, :controller

  alias PhoenixCsvReportsWeb.FallbackController

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
    with {:ok, valid_params} <- Tarams.cast(params, @create_params_schema) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/csv_report/teste")
      |> render(:daily_registrations, csv: "ericserka")
    else
      {:error, errors} -> FallbackController.call(conn, {:error, errors})
    end
  end
end
