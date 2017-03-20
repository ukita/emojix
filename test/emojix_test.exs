defmodule EmojixTest do
  use ExUnit.Case, async: true
  doctest Emojix

  @emojis_amount 1820
  @text          ":man: is on :fire:"

  test "all/0 returns all #{@emojis_amount} emojis" do
    assert Enum.count(Emojix.all) === @emojis_amount
  end

  test "find_by_name/1 returns a list of Emojix.Emoji matched by name" do
    emoji_list = Emojix.find_by_name("dog")

    assert is_list(emoji_list)
    assert Enum.all?(emoji_list, &contains?(&1, :name, "dog"))
  end

  test "find_by_shortname/1 returns a list of Emojix.Emoji matched by shortname" do
    emoji_list = Emojix.find_by_shortname("dog")

    assert is_list(emoji_list)
    assert Enum.all?(emoji_list, &contains?(&1, :shortname, "dog"))
  end

  test "find_by_category/1 returns a list of Emojix.Emoji matched by category" do
    emoji_list = Emojix.find_by_category("people")

    assert is_list(emoji_list)
    assert Enum.all?(emoji_list, &contains?(&1, :category, "people"))
  end

  test "find_by_unicode/1 returns a list of Emojix.Emoji matched by unicode" do
    emoji_list = Emojix.find_by_unicode("1f436")

    assert is_list(emoji_list)
    assert Enum.all?(emoji_list, &contains?(&1, :unicode, "1f436"))
  end

  test "find_by_keyword/1 return Emojix.Emoji matched by keyword" do
    emoji = Emojix.find_by_keyword(":dog:")

    assert %Emojix.Emoji{} = emoji
    assert emoji.shortname === ":dog:"
  end

  test "replace_by_char/1 replace all matched emojis by char" do
    assert Emojix.replace_by_char(@text) === "👨 is on 🔥"
  end

  test "replace_by_html/1 replace all matched emojix by html" do
    expected = ~s(<svg class='emoji-icon'><use xlink:href="/images/emoji.svg#emoji-1f468"></svg> is on <svg class='emoji-icon'><use xlink:href="/images/emoji.svg#emoji-1f525"></svg>)
    assert Emojix.replace_by_html(@text) === expected
  end

  defp contains?(emoji, field, value) do
    String.contains?(Map.get(emoji, field), value)
  end
end
