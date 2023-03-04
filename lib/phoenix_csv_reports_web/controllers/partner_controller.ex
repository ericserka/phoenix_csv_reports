defmodule PhoenixCsvReportsWeb.PartnerController do
  use PhoenixCsvReportsWeb, :controller

  alias PhoenixCsvReports.Reports
  alias PhoenixCsvReports.Reports.Partner

  action_fallback PhoenixCsvReportsWeb.FallbackController

  def index(conn, _params) do
    partners = Reports.list_partners()
    render(conn, :index, partners: partners)
  end

  def create(conn, %{"partner" => partner_params}) do
    with {:ok, %Partner{} = partner} <- Reports.create_partner(partner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/partners/#{partner}")
      |> render(:show, partner: partner)
    end
  end

  def show(conn, %{"id" => id}) do
    partner = Reports.get_partner!(id)
    render(conn, :show, partner: partner)
  end

  def update(conn, %{"id" => id, "partner" => partner_params}) do
    partner = Reports.get_partner!(id)

    with {:ok, %Partner{} = partner} <- Reports.update_partner(partner, partner_params) do
      render(conn, :show, partner: partner)
    end
  end

  def delete(conn, %{"id" => id}) do
    partner = Reports.get_partner!(id)

    with {:ok, %Partner{}} <- Reports.delete_partner(partner) do
      send_resp(conn, :no_content, "")
    end
  end
end
