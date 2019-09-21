defmodule Emojix.Repo do
  @moduledoc false

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def find_by_shortcode(shortcode) do
    GenServer.call(__MODULE__, {:find_by, {:shortcodes, shortcode}})
  end

  def find_by_hexcode(hexcode) do
    GenServer.call(__MODULE__, {:find_by, {:hexcodes, hexcode}})
  end

  def search_by_description(description) do
    GenServer.call(__MODULE__, {:search_by, {:description, description}})
  end

  def search_by_tag(tag) do
    GenServer.call(__MODULE__, {:search_by, {:tags, tag}})
  end

  # Callbacks

  def init(_) do
    {:ok, Emojix.DataLoader.load_table()}
  end

  def handle_call(:all, _from, table) do
    {:reply, select_all(table), table}
  end

  def handle_call({:find_by, {:hexcodes, _hexcode} = value}, _from, table) do
    {:reply, lookup(table, value), table}
  end

  def handle_call({:find_by, value}, _from, table) do
    case lookup(table, value) do
      hexcode when is_binary(hexcode) ->
        {:reply, lookup(table, {:hexcodes, hexcode}), table}

      nil ->
        {:reply, nil, table}
    end
  end

  def handle_call({:search_by, {field, value}}, _from, table) do
    {:reply, search_by(table, field, value), table}
  end

  defp select_all(table) do
    ms = [{{{:"$1", :_}, :"$2"}, [{:==, :"$1", :hexcodes}], [:"$2"]}]
    :ets.select(table, ms)
  end

  defp lookup(table, key) do
    case :ets.lookup(table, key) do
      [{^key, result}] -> result
      _ -> nil
    end
  end

  defp search_by(table, field, value) when field in [:tags, :shortcodes] do
    select_all(table) |> Enum.filter(fn emoji -> Map.get(emoji, field) |> Enum.member?(value) end)
  end

  defp search_by(table, field, value) do
    select_all(table)
    |> Enum.filter(fn emoji -> Map.get(emoji, field) |> String.contains?(value) end)
  end
end
