defmodule PhoenixCsvReports.Pipelines.Reports.GenerateCsv do
  import Ecto.Query
  alias PhoenixCsvReports.Repo
  alias PhoenixCsvReports.Reports.{Registration, Partner}

  def call(report_name, filters) do
    filters
    |> validate_filters()
    |> get_registrations()
    |> generate_csv(report_name)
    |> maybe_return_info_message()
  end

  defp validate_filters(%{start_date: start_date, end_date: end_date} = filters) do
    if Date.compare(start_date, end_date) == :gt do
      {:error, "Start date must be before or equal end date"}
    else
      {:ok, filters}
    end
  end

  defp get_registrations({:error, _} = error), do: error

  defp get_registrations({:ok, %{start_date: start_date, end_date: end_date}}) do
    start_date = NaiveDateTime.new!(start_date, ~T[00:00:00])
    end_date = NaiveDateTime.new!(end_date, ~T[23:59:59])

    registrations =
      Registration
      |> where([r], r.inserted_at >= ^start_date and r.inserted_at <= ^end_date)
      |> join(:inner, [r], p in Partner, on: r.partner_id == p.id)
      |> select([r, p], %{
        registration_date: r.inserted_at,
        partner_name: p.name,
        partner_id: p.id,
        registration_email: r.email,
        registration_id: r.id,
        registration_name: r.name,
        registration_cpf: r.cpf
      })
      |> order_by(asc: :inserted_at)
      |> Repo.all()

    {:ok, registrations}
  end

  defp generate_csv({:error, _} = error, _), do: error

  defp generate_csv({:ok, registrations}, "DailyRegistrations") do
    csvs =
      registrations
      |> Enum.group_by(
        &NaiveDateTime.to_date(&1.registration_date),
        &Map.update!(&1, :registration_date, fn previous_date ->
          NaiveDateTime.to_date(previous_date)
        end)
      )
      |> Map.new(fn {key, value} ->
        {key, value |> CSV.encode(headers: true) |> Enum.to_list() |> to_string()}
      end)

    {:ok, csvs}
  end

  defp generate_csv({:ok, registrations}, "DailyRegistrationsByPartner") do
    csvs =
      registrations
      |> Enum.group_by(
        & &1.partner_id,
        &Map.update!(&1, :registration_date, fn previous_date ->
          NaiveDateTime.to_date(previous_date)
        end)
      )
      |> Map.new(fn {key, value} ->
        {key,
         value
         |> Enum.group_by(& &1.registration_date)
         |> Map.new(fn {key, value} ->
           {key, value |> CSV.encode(headers: true) |> Enum.to_list() |> to_string()}
         end)}
      end)

    {:ok, csvs}
  end

  defp maybe_return_info_message({:error, error_message}), do: error_message

  defp maybe_return_info_message({:ok, output}) when output == %{} do
    "No registrations found for the given filters"
  end

  defp maybe_return_info_message({:ok, output}) do
    output
  end
end
