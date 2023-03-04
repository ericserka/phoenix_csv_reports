defmodule PhoenixCsvReportsWeb.RegistrationJSON do
  alias PhoenixCsvReports.Reports.Registration

  @doc """
  Renders a list of registrations.
  """
  def index(%{registrations: registrations}) do
    %{data: for(registration <- registrations, do: data(registration))}
  end

  @doc """
  Renders a single registration.
  """
  def show(%{registration: registration}) do
    %{data: data(registration)}
  end

  defp data(%Registration{} = registration) do
    %{
      id: registration.id,
      name: registration.name,
      cpf: registration.cpf,
      email: registration.email
    }
  end
end
