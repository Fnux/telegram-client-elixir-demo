defmodule TelegramClient.Listener do
  alias MTProto.Session
  require Logger

  @name TelegramClient.Listener

  def start_link(session_id) do
    GenServer.start_link(__MODULE__, session_id, name: @name)
  end

  def init(session_id) do
    # Register on telegram_mt
    Session.set_client session_id, self()
    {:ok, nil}
  end

  def handle_info({:recv, _session_id, msg}, state) do
    dispatch(msg)
    {:noreply, state}
  end

  defp dispatch(msg) do
    name = if Map.get(msg, :name) == "rpc_result" do
      Map.get(msg, :result) |> Map.get(:name)
    else
      Map.get(msg, :name)
    end

    case name do
      "updateShort" -> :noop #ignore
      "auth.sentCode" -> :noop
      "auth.authorization" ->
        IO.puts "Received user authorization : you are now identified !"
      "updateShortMessage" ->
        %{from_id: sender, message: content} = msg
      IO.puts "New message from #{sender} : #{content}"
      "updateShortChatMessage" ->
        %{from_id: sender, chat_id: chat, message: content} = msg
      IO.puts "New message on chat #{chat} from #{sender} : #{content}"
      _ ->
        IO.puts "-- Unknown message ! --"
        IO.inspect msg
        IO.puts "-----------------------"
    end
  end

  # Bye bye
  def terminate(_,_) do
    :noop
  end
 end
