defmodule PhoenixCsvReportsWeb.RegistrationControllerTest do
  use PhoenixCsvReportsWeb.ConnCase

  import PhoenixCsvReports.ReportsFixtures

  alias PhoenixCsvReports.Reports.Registration

  @create_attrs %{
    cpf: "some cpf",
    email: "some email",
    name: "some name"
  }
  @update_attrs %{
    cpf: "some updated cpf",
    email: "some updated email",
    name: "some updated name"
  }
  @invalid_attrs %{cpf: nil, email: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all registrations", %{conn: conn} do
      conn = get(conn, ~p"/api/registrations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create registration" do
    test "renders registration when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/registrations", registration: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/registrations/#{id}")

      assert %{
               "id" => ^id,
               "cpf" => "some cpf",
               "email" => "some email",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/registrations", registration: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update registration" do
    setup [:create_registration]

    test "renders registration when data is valid", %{conn: conn, registration: %Registration{id: id} = registration} do
      conn = put(conn, ~p"/api/registrations/#{registration}", registration: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/registrations/#{id}")

      assert %{
               "id" => ^id,
               "cpf" => "some updated cpf",
               "email" => "some updated email",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, registration: registration} do
      conn = put(conn, ~p"/api/registrations/#{registration}", registration: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete registration" do
    setup [:create_registration]

    test "deletes chosen registration", %{conn: conn, registration: registration} do
      conn = delete(conn, ~p"/api/registrations/#{registration}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/registrations/#{registration}")
      end
    end
  end

  defp create_registration(_) do
    registration = registration_fixture()
    %{registration: registration}
  end
end
