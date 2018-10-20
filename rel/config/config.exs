config :ex_smtp, client_smtp_opts: [relay: System.get_env("SMTP_RELAY"),
                                           port: System.get_env("SMTP_PORT"),
                                           username: System.get_env("SMTP_USERNAME"),
                                           password: System.get_env("SMTP_PASSWORD")]

config :ex_smtp, smtp_opts: [[port: System.get_env("SMTP_PORT")]]
