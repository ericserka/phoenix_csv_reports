defmodule PhoenixCsvReports.Reports.Partner do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixCsvReports.Reports.Registration

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "partners" do
    field :name, :string
    has_many :registrations, Registration

    timestamps()
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
