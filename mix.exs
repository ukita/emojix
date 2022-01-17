defmodule Emojix.MixProject do
  use Mix.Project

  @version "0.3.1"

  def project do
    [
      app: :emojix,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Emojix.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:castore, "~> 0.1.0"},
      {:mint, "~> 0.4.0 or ~> 1.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Simple emoji library for Elixir. 💩
    """
  end

  defp package do
    [
      maintainers: ["Bruno Ukita <brunoukita@gmail.com>"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ukita/emojix"}
    ]
  end
end
