defmodule Day07P2 do

  def solve(filename) do
    nums =
      File.read!(filename)
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    min =
      nums
      |> Enum.min()
    max =
      nums
      |> Enum.max()

    min..max
    |> Enum.reduce(
         {1000000000000, %{0 => 0}},
         fn n, {prevcost, cache} ->
           {cost, cache} = cost(n, nums, cache)
           {min(cost, prevcost), cache}
         end
       )
    |> elem(0)
  end

  defp cost(target, nums, cache) do
    nums
    |> Enum.reduce(
         {0, cache},
         fn num, {sum, cache} ->
           {move_cost, cache} = move_cost(abs(target - num), cache)
           {sum + move_cost, cache}
         end
       )
  end

  defp move_cost(num, cache) do
    if Map.has_key?(cache, num) do
      {Map.get(cache, num), cache}
    else
      {total, cache} = move_cost(num - 1, cache)
      {total + num, Map.put(cache, num, total + num)}
    end
  end
end
