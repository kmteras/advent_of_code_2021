defmodule AdventOfCode2021.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_2021,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
