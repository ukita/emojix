defmodule Emojix.Mixfile do
  use Mix.Project

  def project do
    [app: :emojix,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     description: description(),
     deps: deps()]
  end

  def application, do: []

  defp package do
    [
      maintainers: ["Bruno Ukita <brunoukita@gmail.com>"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ukita/emojix"}
    ]
  end

  defp description do
    """
    An elixir library that converts emoji in char or svg. 💩
    """
  end

  defp deps do
    [
      {:poison, "~> 3.0"}
    ]
  end
end
