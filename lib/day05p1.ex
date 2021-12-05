defmodule Day05P1 do

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(
         fn line ->
           line
           |> String.split(" -> ")
         end
       )
    |> Enum.map(
         fn [s, e] ->
           [
             s
             |> String.split(","),
             e
             |> String.split(",")
           ]
         end
       )
    |> Enum.filter(fn [[x1, y1], [x2, y2]] -> x1 == x2 || y1 == y2 end)
    |> Enum.reduce(%{}, &process/2)
    |> Map.values()
    |> Enum.reduce(
         0,
         fn value, sum -> if value > 1 do
                            sum + 1
                          else
                            sum
                          end
         end
       )
  end

  defp process([[x1_s, y1_s], [x2_s, y2_s]], map) do
    x1 = String.to_integer(x1_s)
    y1 = String.to_integer(y1_s)
    x2 = String.to_integer(x2_s)
    y2 = String.to_integer(y2_s)

    cond do
      x1 == x2 ->
        y1..y2
        |> Enum.reduce(map, fn y, map -> add_to_map({x1, y}, map) end)

      y1 == y2 ->
        x1..x2
        |> Enum.reduce(map, fn x, map -> add_to_map({x, y1}, map) end)
    end
  end

  defp add_to_map(coords, map) do
    {_, new_map} = map
                   |> Map.get_and_update(
                        coords,
                        fn value ->
                          case value do
                            nil -> {nil, 1}
                            value -> {value, value + 1}
                          end
                        end
                      )
    new_map
  end
end
