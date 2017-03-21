# Emojix

## 💩

An elixir library that converts emoji in char or svg. Supports 1820 emoji.

## Installation

The package can be installed by adding `emojix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:emojix, "~> 0.1.0"}]
end
```

If you want to render in svg, you must run `mix emojix.install` to copy `emoji.svg` inside `priv/static/images`

## Some examples:

```iex
iex> Emojix.all
[%Emojix.Emoji{category: "objects", name: "money bag", shortname: ":moneybag:",
  unicode: "1f4b0"},
 %Emojix.Emoji{category: "objects", name: "banknote with pound sign",
  shortname: ":pound:", unicode: "1f4b7"},
 %Emojix.Emoji{category: "symbols", name: "negative squared cross mark",
  shortname: ":negative_squared_cross_mark:", unicode: "274e"},...]

iex> Emojix.all |> Enum.count
1820

iex> Emojix.replace_by_char("The :man: is on :fire:")
"The 👨 is on 🔥"

iex> Emojix.replace_by_html("I love my :dog:")
"I love my <svg class='emoji-icon'><use xlink:href=\"/images/emoji.svg#emoji-1f436\"></svg>"
```

## TODO

- [ ] write the documentation

## Credits

* Inspired by [Exmoji](https://github.com/mroth/exmoji)
* Emoji provided free by [EmojiOne](http://emojione.com/)
