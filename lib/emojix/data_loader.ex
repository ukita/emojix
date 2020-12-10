defmodule Emojix.DataLoader do
  @moduledoc false

  require Logger

  alias Mint.HTTP

  @ets_table_path Application.app_dir(:emojix, "priv/dataset.ets")
  @download_host "cdn.jsdelivr.net"
  @download_path "/npm/emojibase-data@6.0.0/en/compact.json"
  @download_shortcodes "/npm/emojibase-data@6.0.0/en/shortcodes/iamcal.json"
  @download_legacy_shortcodes "/npm/emojibase-data@6.0.0/en/shortcodes/emojibase-legacy.json"

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
    json = Jason.decode!(download_file(@download_path), keys: :atoms)
    json_shortcodes = Jason.decode!(download_file(@download_shortcodes), keys: :strings)

    json_legacy_shortcodes =
      Jason.decode!(download_file(@download_legacy_shortcodes), keys: :strings)

    shortcodes = merge_shortcodes([json_shortcodes, json_legacy_shortcodes])

    create_table(json, shortcodes)
  end

  defp download_file(path) do
    {:ok, conn} = HTTP.connect(:https, @download_host, 443)

    {:ok, conn, request_ref} =
      HTTP.request(conn, "GET", path, [{"content-type", "application/json"}], "")

    {:ok, conn, body} = stream_request(conn, request_ref)

    Mint.HTTP.close(conn)
    body
  end

  defp merge_shortcodes(list) do
    list
    |> Enum.flat_map(&Map.to_list(&1))
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
  end

  defp create_table(json, json_shortcodes) do
    Logger.debug("Building emoji ets table")
    table = :ets.new(:emoji_table, [:named_table])

    emoji_list =
      parse_json(json, json_shortcodes)
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

  defp parse_json(json, json_shortcodes) do
    json
    |> Stream.filter(&Map.has_key?(&1, :order))
    |> Enum.reduce([], fn emoji, list ->
      [build_emoji_struct(emoji, json_shortcodes) | list]
    end)
  end

  defp build_emoji_struct(emoji, json_shortcodes) do
    shortcodes = Map.get(json_shortcodes, emoji.hexcode, [])

    %Emojix.Emoji{
      id: emoji.order,
      hexcode: emoji.hexcode,
      description: emoji.annotation,
      shortcodes: List.wrap(shortcodes),
      unicode: emoji.unicode,
      tags: Map.get(emoji, :tags, []),
      variations: Map.get(emoji, :skins, []) |> Enum.map(&build_emoji_struct(&1, json_shortcodes))
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
