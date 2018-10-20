defmodule ExSMTP.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    gen_smtp_config = %{
      id: :gen_smtp_server,
      start: {:gen_smtp_server, :start_link, [ExSMTP.Server, Application.get_env(:ex_smtp, :smtp_opts)]}
    }

    children = [
      gen_smtp_config
    ]

    opts = [strategy: :one_for_one, name: ExSMTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
