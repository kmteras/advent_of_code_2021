defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "greets the world" do
    assert Day01.run("day01.txt") == :world
  end
end
