defmodule Emojix.DataLoader do
  @moduledoc false

  require Logger

  alias Mint.HTTP

  @ets_table_path Application.app_dir(:emojix, "priv/dataset.ets")
  @download_host "cdn.jsdelivr.net"
  @download_path "/npm/emojibase-data@latest/en/compact.json"

  @spec load_table :: :emoji_table
  def load_table do
    if table_exists?() do
      {:ok, _} = :ets.file2tab(String.to_charlist(@ets_table_path))

      :emoji_table
    else
      download_and_populate()
    end
  end

  @spec download_and_populate :: :emoji_table
  def download_and_populate do
    Logger.debug("Downloading emoji dataset")
    {:ok, conn} = HTTP.connect(:https, @download_host, 443)

    {:ok, conn, request_ref} =
      HTTP.request(conn, "GET", @download_path, [{"content-type", "application/json"}], "")

    {:ok, conn, body} = stream_request(conn, request_ref)

    Mint.HTTP.close(conn)

    json = Jason.decode!(body, keys: :atoms)

    create_table(json)
  end

  defp create_table(json) do
    Logger.debug("Building emoji ets table")
    table = :ets.new(:emoji_table, [:named_table])

    emoji_list =
      parse_json(json)
      |> Enum.reduce([], fn e, acc ->
        e.variations ++ [e | acc]
      end)

    Logger.debug("Populating table with #{Enum.count(emoji_list)} emojis")

    for emoji <- emoji_list do
      :ets.insert(table, {{:hexcodes, emoji.hexcode}, emoji})

      for shortcode <- emoji.shortcodes do
        :ets.insert(table, {{:shortcodes, shortcode}, emoji.hexcode})
      end
    end

    :ets.tab2file(:emoji_table, String.to_charlist(@ets_table_path))

    :emoji_table
  end

  defp parse_json(json) do
    Enum.reduce(json, [], fn emoji, list ->
      [build_emoji_struct(emoji) | list]
    end)
  end

  defp build_emoji_struct(emoji) do
    %Emojix.Emoji{
      id: emoji.order,
      hexcode: emoji.hexcode,
      description: emoji.annotation,
      shortcodes: emoji.shortcodes,
      unicode: emoji.unicode,
      tags: Map.get(emoji, :tags, []),
      variations: Map.get(emoji, :skins, []) |> Enum.map(&build_emoji_struct/1)
    }
  end

  @spec table_exists? :: boolean
  defp table_exists? do
    File.exists?(@ets_table_path)
  end

  defp stream_request(conn, request_ref, body \\ []) do
    {conn, body, status} =
      receive do
        message ->
          {:ok, conn, responses} = HTTP.stream(conn, message)

          {body, status} =
            Enum.reduce(responses, {body, :incomplete}, fn resp, {body, _status} ->
              case resp do
                {:data, ^request_ref, data} ->
                  {body ++ [data], :incomplete}

                {:done, ^request_ref} ->
                  {body, :done}

                _ ->
                  {body, :incomplete}
              end
            end)

          {conn, body, status}
      end

    if status == :done do
      {:ok, conn, body}
    else
      stream_request(conn, request_ref, body)
    end
  end
end
