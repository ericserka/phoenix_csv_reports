defmodule PhoenixCsvReportsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PhoenixCsvReportsWeb, :controller

  alias PhoenixCsvReportsWeb.ErrorJSON
  alias PhoenixCsvReportsWeb.ErrorHTML
  alias PhoenixCsvReportsWeb.ChangesetJSON

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ErrorHTML, json: ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, errors}) do
    conn
    |> put_status(:bad_request)
    |> put_view(html: ErrorHTML, json: ErrorJSON)
    |> render(:error_with_data, error: errors)
  end
end
