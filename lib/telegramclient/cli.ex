defmodule TelegramClient.CLI do
  alias TelegramClient.Registry

  @registry_list [:dc, :session]
  @dcs [1,2,3,4,5]
  @debug [:debug, :info, :warn, :error]

  def main do
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
      "contacts" -> contacts()
      "debug" -> debug()
      "help" -> print_help()
      "exit" -> System.halt()
      _ -> IO.puts "Unknown command : #{input}"
    end
  end

  def print_help do
    IO.puts """
    --- HELP Message ---
    List of available commands :
    * dump : dump a registry (either :dc or :session)
    * connect : connect to Telegram's servers
    * signin : sign in on Telegram
    * contacts : print the contact list
    * debug : get/set the debug level
    * help : print this message
    * exit : exit this application
    """
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
      TelegramClient.Supervisor.start_link(session_id)
      IO.puts "Wait for the authrorization key, then use the 'signin' command."
    else
      IO.puts "Error: I don't know DC##{dc} ;("
    end
  end

  def sign_in do
    session_id = Registry.get :session_id

    phone = IO.gets("Please enter your phone number (international format) : ")
            |> String.trim
    MTProto.send_code session_id, phone
    code = IO.gets("Please enter your verification code : ")
           |> String.trim
    MTProto.sign_in session_id, phone, code

    IO.puts "Please wait for user authorization."
  end

  def contacts do
    session_id = Registry.get :session_id
    MTProto.send session_id, (MTProto.API.Contacts.get_contacts
                             |> MTProto.Payload.wrap(:encrypted))
  end
end
