defmodule TelegramClient.Listener do
  alias MTProto.Session

  @name TelegramClient.Listener

  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id, name: @name)
  end

  def init(session_id) do
    Session.set_client session_id, self()
    {:ok, nil}
  end

  def handle_info({:recv, msg}, state) do
    IO.puts "TelegramClient received a new message !"
    {:noreply, state}
  end
  
  # Bye bye
  def terminate(_,_) do
    :noop
  end
 end
