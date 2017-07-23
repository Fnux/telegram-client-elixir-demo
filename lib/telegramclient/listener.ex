defmodule TelegramClient.Listener do
  alias MTProto.Session
  require Logger

  @name TelegramClient.Listener

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    # Register on telegram_mt
    session_id = TelegramClient.Registry.get().session_id
    Session.set_client session_id, self()
    {:ok, nil}
  end

  def handle_info({:tg, _session_id, msg}, state) do
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
      "auth.sentCode" ->
        IO.puts "Validation code sent !"
      "auth.authorization" ->
        IO.puts "Received user authorization : you are now identified !"
      "updateShortMessage" ->
        %{from_id: sender, message: content} = msg
        IO.puts "New message from #{sender} : #{content}"
      "updateShortChatMessage" ->
        %{from_id: sender, chat_id: chat, message: content} = msg
        IO.puts "New message on chat #{chat} from #{sender} : #{content}"
      "gzip_packed" ->
        data = Map.get(msg, :result) |> Map.get(:packed_data)
        dispatch(data)
      "contacts.contacts" ->
        process_contacts(msg)
      "messages.dialogs" ->
        process_dialogs(msg)
      "messages.dialogsSlice" ->
        process_dialogs(msg)
      "new_session_created" ->
        IO.puts "New Telegram session created !"
      "msg_container" ->
        contained = Map.get(msg, :messages)
        for msg <- contained do
          dispatch(msg)
        end
      "message" ->
        body = Map.get(msg, :body)
        dispatch(body)
      "msgs_ack" -> :noop #ignore
      _ ->
        IO.puts "-- Unknown message ! --"
        IO.inspect Map.get(msg, :name)
        IO.inspect msg, limit: :infinity
        IO.puts "-----------------------"
    end
  end

  defp process_contacts(data) do
    IO.puts "*** Received contact list ***"
    users = Map.get(data, :users)
    for user <- users do
      id = Map.get(user, :id)
      name = Map.get(user, :first_name) <> Map.get(user, :last_name)
      username = Map.get(user, :username)
      phone = Map.get(user, :phone)

      IO.puts "User ##{id} : #{name} - @#{username} - #{phone}"
    end
  end

  def process_dialogs(msg) do
    for chat <- msg.chats do
      if chat.name == "chat" do
        IO.puts "Chat id##{chat.id} : #{chat.title}"
      end
    end
  end

  # Bye bye
  def terminate(_,_) do
    :noop
  end
 end
