defmodule TelegramClient do
  @dc 4

  def start(_type, _args) do
    {:ok, session_id} = MTProto.connect(@dc)
    TelegramClient.Supervisor.start_link(session_id)
  end

  def sign_in do
    phone = IO.gets("Please enter your phone number :") |> String.trim
    GenServer.call(TelegramClient.Handler, {:send_code, phone})
    code = IO.gets("Please enter the security code") |> String.trim
    GenServer.call(TelegramClient.Handler, {:sign_in, phone, code})
  end
end
