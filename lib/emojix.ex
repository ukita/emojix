defmodule Emojix do
  emoji =
    Application.app_dir(:emojix, "priv/data/emoji.json")
    |> File.read!
    |> Poison.decode!(keys: :atoms)
    |> Enum.map(fn {_name, data} -> struct(Emojix.Emoji, data) end)
  @emoji emoji
  @regex ~r/:[\w]+:/

  def all, do: @emoji

  def find_by_name(name) do
    search_by(:name, name)
  end

  def find_by_shortname(sname) do
    search_by(:shortname, sname)
  end

  def find_by_category(category) do
    search_by(:category, category)
  end

  def find_by_unicode(unicode) do
    search_by(:unicode, unicode)
  end

  def find_by_keyword(keyword) do
    keyword = String.strip(keyword, ?:)
    find_by_shortname(":#{keyword}:")
    |> List.first
  end

  def replace_by_char(text) do
    replace_text(text, :char)
  end

  def replace_by_html(text) do
    replace_text(text, :html)
  end

  defp replace_text(text, opts) do
    Regex.replace(
      @regex,
      text,
      fn keyword, _ ->
        if emoji = Emojix.find_by_keyword(keyword), do: Emojix.Emoji.render(emoji, opts), else: keyword
      end
    )
  end

  defp search_by(field, value) do
    value = String.downcase(value)
    all()
    |> Enum.filter(&String.contains?(Map.get(&1, field), value))
  end
end
