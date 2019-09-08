defmodule Fifo.MixProject do
  use Mix.Project

  @github_url "https://github.com/xtian/fifo"
  @version "0.1.0"

  @description "Modern utilities for working with named pipes (FIFOs)"

  def project do
    [
      app: :fifo,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [
          :error_handling,
          :race_conditions,
          :unmatched_returns
        ]
      ],

      # Hex
      description: @description,
      package: package(),

      # Docs
      name: "Fifo",
      docs: [
        main: "readme",
        extras: ["README.md"],
        source_ref: "v#{@version}",
        source_url: @github_url
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:credo_contrib, "~> 0.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0-rc", only: [:dev, :test], runtime: false},
      {:rustler, "~> 0.21.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Christian Wesselhoeft"],
      licenses: ["ISC"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
