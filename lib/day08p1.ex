defmodule Day08P1 do

  def solve(filename) do
    nums =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn s -> String.split(s, " | ") end)
      |> Enum.map(fn [p1, p2] ->
        [String.split(p1, " "), String.split(p2, " ")]
      end)
      |> Enum.reduce(0, fn splits, sum -> sum + splits_sum(splits) end)
  end

  def splits_sum([_, second]) do
    second
    |> Enum.reduce(0, fn segment, sum ->
      if Enum.member?([2, 4, 3, 7], String.length(segment)) do
        sum + 1
      else
        sum
      end
    end)
  end
end
