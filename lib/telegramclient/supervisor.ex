defmodule TelegramClient.Supervisor do
  use Supervisor

  @name TelegramClient.Supervisor

  def start_link(session_id) do
    Supervisor.start_link(__MODULE__, session_id, name: @name)
  end

  def init(session_id) do
    children = [
      worker(TelegramClient.Registry, [session_id], [restart: :permanent, id: Registry]),
      worker(TelegramClient.Handler, [session_id], [restart: :permanent, id: Handler]),
      worker(TelegramClient.Listener, [session_id], [restart: :permanent, id: Listener]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
