defmodule Day12P2 do

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

  def traverse(map, traversed, point \\ "start", path \\ [], traversed_twice \\ false) do
    cond do
      is_small(point) && MapSet.member?(traversed, point) && !can_traverse_twice(point, traversed_twice) ->
        MapSet.new([])

      point == "end" ->
        MapSet.new([path ++ [point]])

      true ->
        traversed_twice = traversed_twice || is_small(point) && MapSet.member?(traversed, point)
        traversed = MapSet.put(traversed, point)

        map
        |> Map.get(point)
        |> Enum.reduce(
             MapSet.new(),
             fn dir, paths -> MapSet.union(paths, traverse(map, traversed, dir, path ++ [point], traversed_twice)) end
           )
    end
  end

  def can_traverse_twice(point, traversed_twice) do
    cond do
      point == "start" -> false
      point == "end" -> false
      traversed_twice == false -> true
      true -> false
    end
  end

  def is_small(cave) do
    cave != String.upcase(cave)
  end
end
