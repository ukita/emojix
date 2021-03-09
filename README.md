# Emojix 💩

[![Build Status](https://github.com/ukita/emojix/workflows/CI/badge.svg)](https://github.com/ukita/emojix/actions)

Simple Elixir library to help you handle emojis.

## Installation

Add it to your deps list in your mix.exs

```elixir
def deps do
  [
    {:emojix, "~> 0.3.1"}
  ]
end
```

## Usage examples

```elixir
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
```

## Documentation

Full API documentation is available here: https://hexdocs.pm/emojix/

## Credits

Thanks for [@milesj](https://github.com/milesj) for provinding the [emoji datasets](https://github.com/milesj/emojibase).

## License

MIT
