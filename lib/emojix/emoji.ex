defmodule Emojix.Emoji do
  @moduledoc """
  Emoji module
  """
  defstruct [
    name:         nil,
    shortname:    nil,
    category:     nil,
    unicode:      nil
  ]

  def render(%Emojix.Emoji{unicode: unicode}, opts), do: render(unicode, opts)

  def render(unicode, :html) do
    ~s(<svg class='emoji-icon'><use xlink:href="#{emoji_path()}#emoji-#{unicode}"></svg>)
  end

  def render(unicode, :char) do
    unicode
    |> String.split("-")
    |> Enum.map(&String.to_integer(&1, 16))
    |> to_string
  end

  def render(unicode, [path, :png]) do
    ~s(<img src="#{path}/#{unicode}.png"/>)
  end

  def render(unicode, :png) do
    ~s(<img src="#{base_path()}/#{unicode}.png"/>)
  end

  def render(_, _), do: nil

  def char_to_unicode(char) when is_binary(char) do
    char
    |> String.codepoints
    |> Enum.map(&binary_to_hex/1)
    |> Enum.join("-")
  end

  defp binary_to_hex(<<code :: utf8>>) do
    code
    |> Integer.to_string(16)
    |> String.rjust(4,?0)
    |> String.downcase
  end

  defp base_path do
    Application.get_env(:emojix, :path, "/images")
  end

  defp emoji_path do
    "#{base_path()}/emoji.svg"
  end
end
