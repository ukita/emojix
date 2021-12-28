defmodule Emojix.Emoji do
  @moduledoc """
  Documentation for Emojix.Emoji.
  """
  defstruct id: nil,
            hexcode: nil,
            description: nil,
            shortcodes: [],
            tags: [],
            unicode: nil,
            variations: []

  @type t :: %__MODULE__{
          id: integer(),
          hexcode: String.t(),
          description: String.t(),
          shortcodes: [String.t()],
          tags: [String.t()],
          unicode: String.t(),
          variations: [__MODULE__.t()]
        }
end
