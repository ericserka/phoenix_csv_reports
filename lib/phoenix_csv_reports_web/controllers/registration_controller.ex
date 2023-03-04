defmodule PhoenixCsvReportsWeb.RegistrationController do
  use PhoenixCsvReportsWeb, :controller

  alias PhoenixCsvReports.Reports
  alias PhoenixCsvReports.Reports.Registration

  action_fallback PhoenixCsvReportsWeb.FallbackController

  def index(conn, _params) do
    registrations = Reports.list_registrations()
    render(conn, :index, registrations: registrations)
  end

  def create(conn, %{"registration" => registration_params}) do
    with {:ok, %Registration{} = registration} <- Reports.create_registration(registration_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/registrations/#{registration}")
      |> render(:show, registration: registration)
    end
  end

  def show(conn, %{"id" => id}) do
    registration = Reports.get_registration!(id)
    render(conn, :show, registration: registration)
  end

  def update(conn, %{"id" => id, "registration" => registration_params}) do
    registration = Reports.get_registration!(id)

    with {:ok, %Registration{} = registration} <- Reports.update_registration(registration, registration_params) do
      render(conn, :show, registration: registration)
    end
  end

  def delete(conn, %{"id" => id}) do
    registration = Reports.get_registration!(id)

    with {:ok, %Registration{}} <- Reports.delete_registration(registration) do
      send_resp(conn, :no_content, "")
    end
  end
end
