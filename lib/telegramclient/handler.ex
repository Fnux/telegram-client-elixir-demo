defmodule TelegramClient.Handler do
  alias TelegramClient.Registry
  alias MTProto.Session

  @name TelegramClient.Handler

  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id, name: @name)
  end

  def init(session_id) do
    Registry.set :handler, self()
    {:ok, session_id}
  end

  # Authentification
  def handle_call({:send_code, phone}, _from, session_id) do
    MTProto.send_code(session_id, phone)
    {:reply, :ok, session_id}
  end

  def handle_call({:sign_in, phone, code}, _from, session_id) do
    MTProto.sign_in(session_id, phone, code)
    {:reply, :ok, session_id}
  end

  # Send an encrypted message
  def handle_call({:send, msg}, _from, session_id) do
    Session.send session_id, msg |> MTProto.Payload.wrap(:encrypted)
    {:reply, :ok, session_id}
  end

  # Bye bye
  def terminate(_,_) do
    :noop
  end
end
