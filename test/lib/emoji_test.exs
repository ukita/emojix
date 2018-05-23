defmodule Emojix.EmojiTest do
  use ExUnit.Case, async: true

  alias Emojix.Emoji
  @emoji %Emoji{name: "dog face", category: "nature", shortname: ":dog:", unicode: "1f436"}

  test "render/2 render Emoji struct by char" do
    assert Emoji.render(@emoji, :char) === "🐶"
  end

  test "render/2 render Emoji struct by html" do
    expected = ~s(<svg class='emoji-icon'><use xlink:href="/images/emoji.svg#emoji-1f436"></svg>)
    assert Emoji.render(@emoji, :html) === expected
  end

  test "char_to_unicode/1 convert char to unicode" do
    assert Emoji.char_to_unicode("🐶") === "1f436"
  end
end
