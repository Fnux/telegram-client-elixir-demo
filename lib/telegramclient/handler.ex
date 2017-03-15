defmodule TelegramClient.Handler do
  alias MTProto.Session

  @name TelegramClient.Handler
  
  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id, name: @name)
  end

  def init(session_id) do
    session = %TelegramClient.Session{id: session_id}
    {:ok, session}
  end

  # Authentification
  def handle_call({:send_code, phone}, from, session) do
    MTProto.send_code(session.id, phone)
    {:reply, :ok, session}
  end

  def handle_call({:sign_in, phone, code}, from, session) do
    MTProto.sign_in(session.id, phone, code)
    {:reply, :ok, session}
  end

  # Send an encrypted message
  def handle_call({:send, msg}, from, session) do
    Session.send session.id, msg |> MTProto.Payload.wrap(:encrypted)
    {:reply, :ok, session}
  end

  # Bye bye
  def terminate(_,_) do
    :noop
  end
end
