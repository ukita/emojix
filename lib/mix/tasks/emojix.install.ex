defmodule Mix.Tasks.Emojix.Install do
  use Mix.Task

  @shortdoc "Installs Emojix assets"
  @file_path "priv/static/images/emoji.svg"

  @moduledoc """
  Install the Emojix assets in your application

  ## Example
    mix emojix.install
  """
  def run(_) do
    source = Application.app_dir(:emojix, @file_path)
    target = Path.join(".", @file_path)

    Mix.Generator.create_file(target, File.read!(source))
  end
end
