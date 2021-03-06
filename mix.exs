defmodule Mineground.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mineground,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: [
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Minefield.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1.0"},
      {:lonely, "~> 0.3"},
      {:exvcr, "~> 0.8", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: [:dev], runtime: false},
    ]
  end

  defp aliases do
    [check: ["credo --strict", "dialyzer"]]
  end
end
