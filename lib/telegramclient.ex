defmodule TelegramClient do
  alias TelegramClient.CLI

  def start(_type, _args), do: CLI.main()

  def sign_in do
    phone = IO.gets("Please enter your phone number :") |> String.trim
    GenServer.call(TelegramClient.Handler, {:send_code, phone})
    code = IO.gets("Please enter the security code :") |> String.trim
    GenServer.call(TelegramClient.Handler, {:sign_in, phone, code})
  end

  def get_statuses do
    msg = MTProto.API.Contacts.get_statuses
    GenServer.call(TelegramClient.Handler, {:send, msg})
  end

  def sign_out do
    msg = MTProto.API.Auth.log_out
    GenServer.call(TelegramClient.Handler, {:send, msg})
  end
end
