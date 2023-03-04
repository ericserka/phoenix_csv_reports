defmodule PhoenixCsvReportsWeb.PartnerJSON do
  alias PhoenixCsvReports.Reports.Partner

  @doc """
  Renders a list of partners.
  """
  def index(%{partners: partners}) do
    %{data: for(partner <- partners, do: data(partner))}
  end

  @doc """
  Renders a single partner.
  """
  def show(%{partner: partner}) do
    %{data: data(partner)}
  end

  defp data(%Partner{} = partner) do
    %{
      id: partner.id,
      name: partner.name
    }
  end
end
