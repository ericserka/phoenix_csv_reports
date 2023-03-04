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

alias PhoenixCsvReports.Reports
alias PhoenixCsvReports.Reports.{Partner, Registration}
alias PhoenixCsvReports.Repo

Repo.delete_all(Registration)
Repo.delete_all(Partner)

partners =
  for i <- 1..5 do
    {:ok, partner} = Reports.create_partner(%{name: "Partner #{i}"})
    partner
  end

for i <- 1..100 do
  Reports.create_registration(%{
    name: "Registration #{i}",
    cpf: Brcpfcnpj.cpf_generate(),
    email: "email#{i}@hotmail.com",
    partner_id: partners |> Enum.random() |> Map.get(:id)
  })
end
