defmodule PhoenixCsvReportsWeb.Router do
  use PhoenixCsvReportsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixCsvReportsWeb do
    pipe_through :api
  end
end
