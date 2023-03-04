defmodule PhoenixCsvReportsWeb.Router do
  use PhoenixCsvReportsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixCsvReportsWeb do
    pipe_through :api

    resources "/partners", PartnerController, except: [:new, :edit]
    resources "/registrations", RegistrationController, except: [:new, :edit]
    post("/csv_report/:report_name", ReportsController, :create)
  end
end
