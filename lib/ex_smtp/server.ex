defmodule ExSMTP.Server do
  require Logger
  @behaviour :gen_smtp_server_session

  def init(hostname, session_count, _address, _options) do
    if session_count > 500 do
      Logger.warn("SMTP server connection limit exceeded")
      {:stop, :normal, ["421", hostname, " is too busy to accept mail right now"]}
    else
      banner = [hostname, " ESMTP (EX SMTP)"]
      state = %{}
      {:ok, banner, state}
    end
  end

  def handle_HELO(hostname, state) do
    Logger.info("HELO from #{hostname}")
    {:ok, 655_360, state}
  end

  def handle_EHLO(hostname, extensions, state) do
    Logger.info("EHLO from #{hostname}")
    {:ok, extensions, state}
  end

  def handle_MAIL(from, state) do
    Logger.info("MAIL from #{from}")
    {:ok, Map.put(state, "from", from)}
  end

  def handle_MAIL_extension(<<"X-SomeExtension">> = extension, state) do
    Logger.info("Mail from extension #{inspect(extension)}")
    {:ok, state}
  end

  def handle_MAIL_extension(extension, state) do
    Logger.info("Mail from unknown extension #{inspect(extension)}")
    {["500 Error: extension not recognized : #{extension}"], state}
  end

  def handle_RCPT(to, state) do
    Logger.info("RCPT to #{to}")
    {:ok, Map.put(state, "to", to)}
  end

  def handle_RCPT_extension(extension, state) do
    Logger.info(extension)
    {:ok, state}
  end

  def handle_DATA(_from, _to, data, state) do
    decoded_data = decode_email(data)

    Logger.info("DATA: #{inspect(decoded_data)}")

    {:ok, "", state}
  end

  def handle_RSET(state) do
    {:ok, state}
  end

  def handle_VRFY(address, state) do
    Logger.info(address)
    {:ok, state}
  end

  #def handle_STARTTLS(state) do
    #Logger.info("Starting TLS #{inspect(state)}")
    #{:ok, state}
  #end

  def handle_other("PING", _args, state) do
    {["250 OK: PONG"], state}
  end

  def handle_other(command, _args, state) do
    Logger.info(command)
    {["500 Error: command not recognized : #{command}"], state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  def terminate(reason, state) do
    Logger.info("Terminating Session: #{reason}")
    {:ok, state}
  end

  defp decode_email(data) when is_bitstring(data) do
    try do
      :mimemail.decode(data)
    rescue
      reason ->
        :io.format("Message decode FAILED with ~p:~n", [reason])
    end
  end
end
