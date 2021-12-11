defmodule Day11P2 do

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(
         %{},
         fn {line, y}, map ->
           line
           |> Enum.with_index()
           |> Enum.reduce(
                %{},
                fn {el, x}, map -> Map.put(map, {x, y}, String.to_integer(el))
                end
              )
           |> Map.merge(map)
         end
       )
    |> tick()
  end

  def tick(map, step \\ 0) do
    map =
      map
      |> Map.map(fn {key, val} -> val + 1 end)
      |> flash(MapSet.new([]))

    flashes =
      map
      |> Enum.reduce(
           0,
           fn {_, value}, sum ->
             if value > 9 do
               sum + 1
             else
               sum
             end
           end
         )

    map = Map.map(
      map,
      fn {_, value} ->
        if value > 9 do
          0
        else
          value
        end
      end
    )

    if flashes == 100 do
      step + 1
    else
      tick(map, step + 1)
    end
  end

  def do_tick(elem, {flashes, map}) do
    {flashes, map}
  end

  def flash(map, has_flashed) do
    case Enum.find(map, fn {key, value} -> !MapSet.member?(has_flashed, key) && value > 9 end) do
      {coords, value} ->
        map = increase_neighbors(map, coords)
        flash(map, MapSet.put(has_flashed, coords))
      nil ->
        map
    end
  end

  def increase_neighbors(map, {x, y}) do
    [
      {-1, -1},
      {-1, 0},
      {-1, +1},
      {0, -1},
      {0, +1},
      {+1, -1},
      {+1, 0},
      {+1, +1}
    ]
    |> Enum.reduce(
         map,
         fn {of, oy}, map ->
           key = {x + of, y + oy}
           if Map.has_key?(map, key) do
             Map.update!(map, key, fn ex -> ex + 1 end)
           else
             map
           end
         end
       )
  end
end
