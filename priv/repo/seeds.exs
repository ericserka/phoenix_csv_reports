# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixCsvReports.Repo.insert!(%PhoenixCsvReports.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixCsvReports.Reports.{Partner, Registration}
alias PhoenixCsvReports.Repo

Repo.delete_all(Registration)
Repo.delete_all(Partner)

partners =
  Enum.map(
    1..5,
    &(%Partner{}
      |> Partner.changeset(%{name: "Partner #{&1}"})
      |> Repo.insert!())
  )

dates_range = Date.range(~D[2022-05-20], ~D[2023-05-20])

Repo.insert_all(
  Registration,
  Enum.map(
    1..1000,
    fn i ->
      date = dates_range |> Enum.random() |> NaiveDateTime.new!(~T[00:00:00])

      %{
        name: "Registration #{i}",
        cpf: Brcpfcnpj.cpf_generate(),
        email: "email#{i}@hotmail.com",
        partner_id: partners |> Enum.random() |> Map.get(:id),
        inserted_at: date,
        updated_at: date
      }
    end
  )
)
