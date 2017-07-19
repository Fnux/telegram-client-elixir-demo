defmodule TelegramClient.Supervisor do
  use Supervisor

  @name TelegramClient.Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      worker(TelegramClient.Registry, [], [restart: :permanent, id: Registry])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def start_listener() do
    listener = worker(TelegramClient.Listener, [], [restart: :permanent, id: Listener])
    Supervisor.start_child @name, listener
  end

  def exit() do
    Supervisor.terminate_child @name, Listener
    Supervisor.terminate_child @name, Registry
    Supervisor.stop(@name)
  end
end
