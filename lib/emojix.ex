defmodule Emojix do
  @moduledoc """
  Documentation for Emojix.
  """

  alias Emojix.Repo

  @doc """
  Returns a list of all 3019 Emoji, including variations.
  ## Examples
      iex> Emojix.all()
        [
          %Emojix.Emoji{
            description: "flag: Andorra",
            hexcode: "1F1E6-1F1E9",
            id: 3577,
            shortcodes: ["flag_ad"],
            tags: ["AD", "flag"],
            unicode: "🇦🇩",
            variations: []
          },
          %Emojix.Emoji{
            description: "downcast face with sweat",
            hexcode: "1F613",
            id: 85,
            shortcodes: ["shamed"],
            tags: ["cold", "face", "sweat"],
            unicode: "😓",
            variations: []
          },
        ...
      ]
  """
  @spec all() :: [Emojix.Emoji.t()]
  def all, do: Repo.all()

  @doc """
  Find a emoji by shortcode
  ## Examples
      iex> Emojix.find_by_shortcode("gleeful")
      %Emojix.Emoji{
        description: "grinning face",
        hexcode: "1F600",
        id: 1,
        shortcodes: ["gleeful"],
        tags: ["face", "grin"],
        unicode: "😀",
        variations: []
      }
      iex> Emojix.find_by_shortcode("non_valid")
      nil
  """
  @spec find_by_shortcode(String.t()) :: Emojix.Emoji.t() | nil
  def find_by_shortcode(shortcode) do
    shortcode |> String.downcase() |> Repo.find_by_shortcode()
  end

  @doc """
  Find a emoji by unicode
  ## Examples
      iex> Emojix.find_by_shortcode("😼")
      %Emojix.Emoji{
        description: "cat with wry smile",
        hexcode: "1F63C",
        id: 110,
        shortcodes: ["smirking_cat"],
        tags: ["cat", "face", "ironic", "smile", "wry"],
        unicode: "😼",
        variations: []
      }
  """
  @spec find_by_unicode(String.t()) :: nil | Emojix.Emoji.t()
  def find_by_unicode(unicode) do
    unicode
    |> String.to_charlist()
    |> Enum.map(&Integer.to_string(&1, 16))
    |> Enum.join("-")
    |> find_by_hexcode()
  end

  @doc """
  Find a emoji by hexcode
  ## Examples
      iex> Emojix.find_by_hexcode("1F600")
      %Emojix.Emoji{
        description: "grinning face",
        hexcode: "1F600",
        id: 1,
        shortcodes: ["gleeful"],
        tags: ["face", "grin"],
        unicode: "😀",
        variations: []
      }
      iex> Emojix.find_by_hexcode("FFFFF")
      nil
  """
  @spec find_by_hexcode(String.t()) :: Emojix.Emoji.t() | nil
  def find_by_hexcode(hexcode) do
    hexcode |> String.upcase() |> Repo.find_by_hexcode()
  end

  @doc """
  Search a emoji by description
  ## Examples
      iex> Emojix.search_by_description("grinning")
      [
        %Emojix.Emoji{
          description: "grinning face with sweat",
          hexcode: "1F605",
          id: 6,
          shortcodes: ["embarassed"],
          tags: ["cold", "face", "open", "smile", "sweat"],
          unicode: "😅",
          variations: []
        },
        %Emojix.Emoji{
          description: "grinning cat with smiling eyes",
          hexcode: "1F638",
          id: 107,
          shortcodes: ["grinning_cat"],
          tags: ["cat", "eye", "face", "grin", "smile"],
          unicode: "😸",
          variations: []
        },
        ...
      ]
      iex> Emojix.search_by_description("blah")
      []
  """
  @spec search_by_description(String.t()) :: [Emojix.Emoji.t()] | []
  def search_by_description(description) do
    description |> String.downcase() |> Repo.search_by_description()
  end

  @doc """
  Search a emoji by tag
  ## Examples
      iex> Emojix.search_by_tag("face")
      [
        %Emojix.Emoji{
          description: "downcast face with sweat",
          hexcode: "1F613",
          id: 85,
          shortcodes: ["shamed"],
          tags: ["cold", "face", "sweat"],
          unicode: "😓",
          variations: []
        },
        %Emojix.Emoji{
          description: "smiling face with sunglasses",
          hexcode: "1F60E",
          id: 61,
          shortcodes: ["confident"],
          tags: ["bright", "cool", "face", "sun", "sunglasses"],
          unicode: "😎",
          variations: []
        },
        ...
      ]
      iex> Emojix.search_by_tag("blah")
      []
  """
  @spec search_by_tag(String.t()) :: [Emojix.Emoji.t()] | []
  def search_by_tag(tag) do
    tag |> String.downcase() |> Repo.search_by_tag()
  end

  @doc """
  Returns a new string where each emoji contained in the given string is applied to a function.
  ## Examples
      iex> Emojix.replace("The 🐶 likes 🦴", fn e -> e.shortcodes end)
      "The dog_face likes bone"
  """
  @spec replace(String.t(), (Emojix.Emoji.t() -> any)) :: String.t()
  def replace(str, fun) do
    str
    |> String.graphemes()
    |> Enum.map(fn grapheme ->
      case find_by_unicode(grapheme) do
        %Emojix.Emoji{} = emoji ->
          fun.(emoji)

        nil ->
          grapheme
      end
    end)
    |> Enum.join()
  end

  @doc """
  Returns a list of all emoji contained within that string, in order.

  ## Examples
      iex> Emojix.scan("Elixir is awesome!! ✌🏻👍🏽")
      [
        %Emojix.Emoji{
          description: "victory hand: light skin tone",
          hexcode: "270C-1F3FB",
          id: 206,
          shortcodes: ["victory_tone1"],
          tags: [],
          unicode: "✌🏻",
          variations: []
        },
        %Emojix.Emoji{
          description: "thumbs up: medium skin tone",
          hexcode: "1F44D-1F3FD",
          id: 275,
          shortcodes: ["thumbsup_tone3", "+1_tone3", "yes_tone3"],
          tags: [],
          unicode: "👍🏽",
          variations: []
        }
      ]
      iex> Emojix.scan("There is no emoji in this sentence")
      []
  """
  @spec scan(String.t()) :: [Emojix.Emoji.t()]
  def scan(str) do
    str
    |> String.graphemes()
    |> Enum.reverse()
    |> _scan()
  end

  defp _scan(graphemes, emojis \\ [])

  defp _scan([], emojis), do: Enum.uniq(emojis)

  defp _scan([h | t], emojis) when byte_size(h) >= 3 do
    case find_by_unicode(h) do
      %Emojix.Emoji{} = emoji ->
        _scan(t, [emoji | emojis])

      nil ->
        _scan(t, emojis)
    end
  end

  defp _scan([_ | t], emojis), do: _scan(t, emojis)
end
