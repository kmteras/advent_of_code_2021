defmodule Mix.Tasks.Day do
  use Mix.Task

  def run(_args) do
    Day02P2.run("input/day02.txt")
  end
end
