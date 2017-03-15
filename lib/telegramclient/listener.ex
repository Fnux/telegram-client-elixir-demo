defmodule TelegramClient.Listener do
  alias MTProto.Session
  require Logger

  @name TelegramClient.Listener

  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id, name: @name)
  end

  def init(session_id) do
    Session.set_client session_id, self()
    {:ok, nil}
  end

  def handle_info({:recv, session_id, msg}, state) do
    name = Map.get(msg, :name)
    result = if name == "rpc_result" do
      Map.get(msg, :result) |> Map.get(:name)
    else
      name
    end

    Logger.info "TelegramClient received a new message : #{result}"
    {:noreply, state}
  end
  
  # Bye bye
  def terminate(_,_) do
    :noop
  end
 end
