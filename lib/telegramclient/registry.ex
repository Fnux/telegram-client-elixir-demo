defmodule TelegramClient.Registry do
  use GenServer

  @name __MODULE__

  defstruct session_id: nil

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    state = struct(__MODULE__)

    {:ok, state}
  end

  ###

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:update, change}, _from, state) do
    updated = struct(state, change)
    {:reply, updated, updated}
  end

  ###

  def get() do
    GenServer.call(@name, :get)
  end

  def update(change) do
    GenServer.call(@name, {:update, change})
  end
end
