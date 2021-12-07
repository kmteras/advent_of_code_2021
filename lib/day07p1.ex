defmodule Day07P1 do

  def solve(filename) do
    nums =
      File.read!(filename)
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    min = nums
          |> Enum.min()
    max = nums
          |> Enum.max()

    min..max
    |> Enum.map(fn n -> cost(n, nums) end)
    |> Enum.min()
  end

  defp cost(target, nums) do
    nums
    |> Enum.reduce(
         0,
         fn num, sum ->
           (sum + abs(target - num))
         end
       )
  end
end
