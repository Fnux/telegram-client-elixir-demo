defmodule TelegramClient do
  alias TelegramClient.CLI

  def main(args \\ []) do
    # Launch telegram client
    MTProto.start()

    # Start CLI
    CLI.main(args)
  end
end
