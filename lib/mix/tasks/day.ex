defmodule Mix.Tasks.Day do
  use Mix.Task

  def run(_args) do
    Day01P2.run("input/day01.txt")
  end
end
