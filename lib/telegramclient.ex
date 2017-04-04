defmodule TelegramClient do
  alias TelegramClient.CLI

  def start(_type, _args), do: CLI.main()
end
