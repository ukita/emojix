defmodule EmojixTest do
  use ExUnit.Case

  test "list all the emojis" do
    assert length(Emojix.all()) === 3019
  end

  test "find emoji by shortcode" do
    test_cases = [
      %{shortcode: "gleeful", expected: "grinning face"},
      %{shortcode: "flag_au", expected: "flag: Australia"},
      %{shortcode: "medium_small_black_square", expected: "black medium-small square"}
    ]

    Enum.each(test_cases, fn t ->
      emoji = Emojix.find_by_shortcode(t.shortcode)
      assert emoji.description === t.expected
    end)
  end

  test "return nil when emoji not found by shortcode" do
    assert is_nil(Emojix.find_by_shortcode("INVALID"))
  end

  test "find emoji by unicode" do
    test_cases = [
      %{unicode: "👨🏼‍🦱", expected: "man: medium-light skin tone, curly hair"},
      %{unicode: "🇪🇸", expected: "flag: Spain"},
      %{unicode: "🖐🏾", expected: "hand with fingers splayed: medium-dark skin tone"}
    ]

    Enum.each(test_cases, fn t ->
      emoji = Emojix.find_by_unicode(t.unicode)
      assert emoji.description === t.expected
    end)
  end

  test "return nil when emoji not found by unicode" do
    assert is_nil(Emojix.find_by_unicode("INVALID"))
  end

  test "find emoji by hexcode" do
    test_cases = [
      %{hexcode: "1F1EC-1F1F1", expected: "flag: Greenland"},
      %{hexcode: "1F6A2", expected: "ship"},
      %{hexcode: "1F3DB", expected: "classical building"}
    ]

    Enum.each(test_cases, fn t ->
      emoji = Emojix.find_by_hexcode(t.hexcode)
      assert emoji.description === t.expected
    end)
  end

  test "return nil when emoji not found by hexcode" do
    assert is_nil(Emojix.find_by_hexcode("INVALID"))
  end

  test "search a emoji by description" do
    test_cases = [
      %{
        description: "brick",
        expected: [
          2668
        ]
      },
      %{
        description: "dog",
        expected: [2386, 2388, 2387, 2389, 2562]
      }
    ]

    Enum.each(test_cases, fn t ->
      emoji_list = Emojix.search_by_description(t.description)
      assert Enum.any?(emoji_list, fn e -> Enum.member?(t.expected, e.id) end)
    end)
  end

  test "return empty list when emoji not found by description" do
    assert Emojix.search_by_description("BLAHBLEH") == []
  end

  test "search a emoji by tag" do
    test_cases = [
      %{
        tag: "boat",
        expected: [2778, 1903, 1915, 2775, 2771, 1897, 2769, 2777, 2770]
      },
      %{
        tag: "bleed",
        expected: [3240]
      }
    ]

    Enum.each(test_cases, fn t ->
      emoji_list = Emojix.search_by_tag(t.tag)
      assert Enum.any?(emoji_list, fn e -> Enum.member?(t.expected, e.id) end)
    end)
  end

  test "return empty list when emoji not found by tag" do
    assert Emojix.search_by_tag("BLAHBLEH") == []
  end

  test "scan a string and return all the contained emojis" do
    test_cases = [
      %{
        text: "⁣
                  🎈🎈  ☁️
                🎈🎈🎈
        ☁️     🎈🎈🎈🎈
                🎈🎈🎈🎈
          ☁️    ⁣🎈🎈🎈
                  \|/
                  🏠   ☁️
          ☁️         ☁️
        🌳🌹🏫🌳🏢🏢_🏢🏢🌳🌳
        ",
        expected: ["🎈", "🏠️", "🌳", "🌹", "🏫", "🏢"]
      },
      %{
        text: "
          ⁣⚪⚪⚪⚪⚪⚪⚪
          ⚪⚪⚪⚪⚪⚪⚪
          ⁣⚪⚪⚪⚪⚪⚪⚪
          ⚪⚪🔵🔴⚪⚪⚪
      ",
        expected: ["⚪️", "🔵", "🔴"]
      }
    ]

    Enum.each(test_cases, fn t ->
      emoji_list = Emojix.scan(t.text)
      assert Enum.any?(emoji_list, fn e -> Enum.member?(t.expected, e.unicode) end)
    end)
  end

  test "return empty list when sentence has no emoji" do
    assert Emojix.scan("BLAHBLEH") == []
  end

  test "replace a emoji with a given function" do
    test_cases = [
      %{
        string: "🌍 ain't the kind of place to raise your 👨‍👩‍👧‍👦",
        expected: ":emoji: ain't the kind of place to raise your :emoji:"
      },
      %{
        string: "🚀 👨🏻 🔥 out his fuse up here alone",
        expected: ":emoji: :emoji: :emoji: out his fuse up here alone"
      }
    ]

    Enum.each(test_cases, fn t ->
      str = Emojix.replace(t.string, fn _ -> ":emoji:" end)
      assert str == t.expected
    end)
  end
end
