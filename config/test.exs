import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phoenix_csv_reports, PhoenixCsvReports.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "phoenix_csv_reports_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_csv_reports, PhoenixCsvReportsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8yZ82g3mp4ZeBtUbDZ9CROMfw4nyoNDzdUT7kWywJ4ZLqK03X8ziJZZI2/jpRefV",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
