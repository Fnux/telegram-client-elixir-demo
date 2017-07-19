defmodule TelegramClient do
  def main(args \\ []) do
    # Launch telegram client
    MTProto.start()

    # Launch client supervisor
    TelegramClient.Supervisor.start_link()

    # Start CLI
    TelegramClient.CLI.main(args)
  end
end
