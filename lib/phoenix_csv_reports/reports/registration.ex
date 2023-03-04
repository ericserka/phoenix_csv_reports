defmodule PhoenixCsvReports.Reports.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixCsvReports.Reports.Partner

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "registrations" do
    field :cpf, :string
    field :email, :string
    field :name, :string
    belongs_to :partner, Partner

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:name, :cpf, :email])
    |> validate_required([:name, :cpf, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_cpf()
  end

  defp validate_cpf(changeset) do
    cpf = get_field(changeset, :cpf)

    if Brcpfcnpj.cpf_valid?(cpf) do
      changeset
    else
      add_error(changeset, :cpf, "is invalid")
    end
  end
end
