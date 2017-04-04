defmodule TelegramClient.Registry do
  use GenServer

  @name __MODULE__

  def start_link(session_id) do
    Registry.start_link(:unique, @name)
    Registry.register(@name, :session_id, session_id)
  end

  def keys, do: Registry.keys(@name, self)

  def set(key, value) do
    Registry.register(@name, key, value)
  end

  def drop(key) do
    Registry.unregister(@name, key)
  end

  def get(key) do
    {_, value} = Registry.lookup(@name, key) |> List.first
    value
  end
end
