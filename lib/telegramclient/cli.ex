defmodule TelegramClient.CLI do
  alias TelegramClient.{Supervisor, Registry}

  @registry_list [:dc, :session]
  @dcs [0,1,2,3,4,5] # 0 -> test DC
  @debug [:debug, :info, :warn, :error]
  @export "authkey-export"

  def main(_) do
    IO.puts "Welcome abord `telegram-client-elixir-demo` !"
    IO.puts "Type `help` for the available commands."
    loop()
  end

  def loop do
    input = IO.gets("> ") |> String.trim

    process(input)
    loop()
  end

  def process(input) do
    case input do
      "dump" -> dump()
      "connect" -> connect()
      "signin" -> sign_in()
      "signup" -> sign_up()
      "send" -> send()
      "contacts" -> get_contacts()
      "chats" -> get_chats()
      "debug" -> debug()
      "akgen" -> gen_authkey()
      "export" -> export_session()
      "import" -> import_session()
      "help" -> print_help()
      "exit" -> stop()
      "q" -> stop()
      "" -> :noop # ignore
      _ -> IO.puts "Unknown command : #{input}"
    end
  end

  def print_help do
    IO.puts """
    --- HELP Message ---
    List of available commands :
    * help : print this message
    * connect : connect to Telegram's servers
    * signin : sign in on Telegram
    * send : send a message
    * contacts : print the contact list
    * chats : print the chats list
    * akgen : generate the authorization key
    * export : export session parameters
    * import : import session parameters
    * exit : exit this application
    Debug commands :
    * debug : get/set the debug level
    * dump : dump a registry (either :dc or :session)
    --- Signin procedure ---
    * connect -> gen-authkey -> signin
    """
  end

  ###
  # "available" commands

  def connect do
    IO.write "Available DCs : "
    IO.inspect @dcs
    {dc, _} = IO.gets("Please select which DC you want to connect to : ")
              |> String.trim
              |> Integer.parse

    if dc in @dcs do
      IO.puts "Starting..."
      {:ok, session_id} = MTProto.connect(dc)
      IO.puts "Your session ID is #{session_id}."

      Registry.update(session_id: session_id)
      Supervisor.start_listener()
    else
      IO.puts "Error: I don't know DC##{dc} ;("
    end
  end

  def gen_authkey() do
    session_id = Registry.get().session_id

    IO.puts "Requesting Authorization Key..."
    MTProto.request_authkey(session_id)
  end

  def send_code(session_id) do
    phone = IO.gets("Please enter your phone number (international format) : ")
            |> String.trim
    {:ok, _msg_id} = MTProto.send_code session_id, phone

    phone
  end

  def sign_in do
    session_id = Registry.get().session_id
    phone = send_code(session_id)

    code = IO.gets("Please enter your verification code : ")
           |> String.trim
    MTProto.sign_in session_id, phone, code

    IO.puts "Please wait for user authorization."
  end

  def sign_up do
    session_id = Registry.get().session_id
    phone = send_code(session_id)

    code = IO.gets("Please enter your verification code : ")
           |> String.trim
    first_name = IO.gets("Please enter your first name : ")
           |> String.trim
    last_name = IO.gets("Please enter your last name : ")
           |> String.trim

    phone_code_hash = MTProto.Session.get(session_id).phone_code_hash
    query = MTProto.API.Auth.sign_up phone, phone_code_hash, code, first_name, last_name
    MTProto.Session.send session_id, query
  end

  def get_contacts do
    session_id = Registry.get().session_id
    MTProto.send session_id, MTProto.API.Contacts.get_contacts
  end

  def get_chats do
    session_id = Registry.get().session_id
    MTProto.send session_id, MTProto.API.Messages.get_dialogs(0,0,1000)
  end

  def send do
    session_id = Registry.get().session_id
    dst = IO.gets("Please enter the ID of the recipient : ") |> String.trim
                                                             |> String.to_integer
    msg = IO.gets("Message : ") |> String.trim
    MTProto.send_message session_id, dst, msg
  end


  def export_session() do
    IO.puts "Exporting Authorization Key..."

    session_id = Registry.get().session_id
    {user_id, auth_key, server_salt} = MTProto.Session.export(session_id)
    export = Integer.to_string(user_id) <> ";;" <> auth_key <> ";;" <> server_salt

    IO.puts "Writing to #{@export}..."
    {:ok, file} = File.open @export, [:write]
    IO.binwrite file, export
    File.close file
    IO.puts "Export complete."
  end

  def import_session() do
    IO.puts "Opening #{@export}..."
    {:ok, export} = File.read @export
    [user_id, auth_key, server_salt] = String.split(export, ";;")
    IO.puts "Importing authorization key..."
    session_id = Registry.get().session_id
    MTProto.Session.import(
      session_id,
      String.to_integer(user_id),
      auth_key,
      server_salt
    )
  end

  def stop() do
    System.halt()
  end

  ###
  # "Debug" commands

  def debug() do
    IO.puts "The current debug level is :#{Logger.level}."
    change = IO.gets("Change the debug level? [y/n] ") |> String.trim

    if change in ["y", "Y"] do
      IO.write "Available debug levels : "
      IO.inspect @debug
      level = IO.gets("Please select the new debug level : ")
              |> String.trim
              |> String.to_atom

      if level in @debug do
        Logger.configure(level: level)
        IO.puts "Debug level changed to #{level}."
      else
        IO.puts "Error: the is no #{level} level."
      end
    end
  end

  def dump do
    registry = IO.gets("Please enter the registry to dump : ")
               |> String.trim
               |> String.to_atom

    if registry in @registry_list do
      IO.inspect MTProto.Registry.dump registry
    else
      IO.puts "Error: no such registry!"
    end
  end
end
