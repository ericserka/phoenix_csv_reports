defmodule PhoenixCsvReportsWeb.ReportsControllerTest do
  use PhoenixCsvReportsWeb.ConnCase

  @valid_attrs %{
    start_date: ~D[2022-05-20],
    end_date: ~D[2022-05-21]
  }
  @invalid_attrs %{
    start_date: "2022-ab-cd",
    end_date: "2023-01-0a"
  }
  @future_attrs %{
    start_date: ~D[2025-05-20],
    end_date: ~D[2025-05-21]
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "renders data when data is valid and DailyRegistrationsByPartner is the report_name", %{
    conn: conn
  } do
    conn =
      post(conn, ~p"/api/csv_report/DailyRegistrationsByPartner",
        start_date: @valid_attrs.start_date,
        end_date: @valid_attrs.end_date
      )

    data = conn |> json_response(200) |> Map.get("data")
    assert data |> Map.keys() |> Enum.all?(&is_uuid?(&1))

    dates = Map.values(data)
    assert Enum.all?(dates, &is_map(&1))
    assert dates |> Enum.map(&(&1 |> Map.keys() |> Enum.all?(fn x -> is_date?(x) end)))
    assert dates |> Enum.map(&(&1 |> Map.values() |> Enum.all?(fn x -> is_binary(x) end)))
  end

  test "renders data when data is valid and DailyRegistrations is the report_name", %{conn: conn} do
    conn =
      post(conn, ~p"/api/csv_report/DailyRegistrations",
        start_date: @valid_attrs.start_date,
        end_date: @valid_attrs.end_date
      )

    data = conn |> json_response(200) |> Map.get("data")
    assert data |> Map.keys() |> Enum.all?(&is_date?(&1))
    assert data |> Map.values() |> Enum.all?(&is_binary(&1))
  end

  test "renders data even when dates not passed in parameters", %{conn: conn} do
    conn = post(conn, ~p"/api/csv_report/DailyRegistrations")

    assert json_response(conn, 200)["data"] != %{}
  end

  test "renders errors when data is invalid", %{conn: conn} do
    conn =
      post(conn, ~p"/api/csv_report/DailyRegistrationsByPartner",
        start_date: @invalid_attrs.start_date,
        start_date: @invalid_attrs.end_date
      )

    assert json_response(conn, 400)["error"] != %{}
  end

  test "renders error when start_date is greater than end_date", %{conn: conn} do
    conn =
      post(conn, ~p"/api/csv_report/DailyRegistrations",
        start_date: @valid_attrs.end_date,
        end_date: @valid_attrs.start_date
      )

    assert json_response(conn, 400)["error"] == "Start date must be before or equal end date"
  end

  test "renders error when no registration is found with the given filters dates", %{conn: conn} do
    conn =
      post(conn, ~p"/api/csv_report/DailyRegistrations",
        start_date: @future_attrs.start_date,
        end_date: @future_attrs.end_date
      )

    assert json_response(conn, 400)["error"] == "No registrations found for the given filters"
  end

  defp is_date?(string) do
    string
    |> Date.from_iso8601()
    |> case do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp is_uuid?(string) do
    string
    |> Ecto.UUID.cast()
    |> case do
      {:ok, _} ->
        true

      :error ->
        false
    end
  end
end
