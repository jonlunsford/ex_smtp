use Mix.Config

config :ex_smtp, smtp_opts: [[port: String.to_integer(System.get_env("SMTP_PORT"))]]
