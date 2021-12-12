defmodule Day12P1 do

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(
         %{},
         fn [s, e], map ->
           Map.update(map, s, [e], fn ex -> ex ++ [e] end)
           |> Map.update(e, [s], fn ex -> ex ++ [s] end)
         end
       )
    |> traverse(MapSet.new())
    |> MapSet.size()
  end

  def traverse(map, traversed, point \\ "start", path \\ []) do
    cond do
      is_small(point) && MapSet.member?(traversed, point) -> MapSet.new([])

      point == "end" -> MapSet.new([path ++ [point]])

      true ->
        traversed = MapSet.put(traversed, point)

        map
        |> Map.get(point)
        |> Enum.reduce(
             MapSet.new(),
             fn dir, paths -> MapSet.union(paths, traverse(map, traversed, dir, path ++ [point])) end
           )
    end
  end

  def is_small(cave) do
    cave != String.upcase(cave)
  end
end
