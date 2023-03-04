defmodule PhoenixCsvReports.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
