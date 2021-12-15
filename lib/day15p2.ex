defmodule Day15P2 do

  def solve(filename) do
    coords =
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
                  fn {risk, x}, map -> Map.put(map, {x, y}, String.to_integer(risk)) end
                )
             |> Map.merge(map)
           end
         )

    max_coords = max_coords(coords)

    coords = expand(coords, max_coords)

    max_coords = max_coords(coords)

    rap = lowest_risk(coords, max_coords, %{{0, 0} => 0})
    Map.get(rap, max_coords)
  end

  defp max_coords(coords) do
    Enum.reduce(
      coords,
      {0, 0},
      fn {{x, y}, _}, {px, py} = prev ->
        if x >= px && y >= py do
          {x, y}
        else
          prev
        end
      end
    )
    |> IO.inspect()
  end

  defp expand(orig_coords, {mx, my}) do
    width = mx + 1
    height = my + 1

    new_coords =
      0..width * 5 - 1
      |> Enum.reduce(
           orig_coords,
           fn x, coords ->
             0..height * 5 - 1
             |> Enum.reduce(
                  coords,
                  fn y, coords ->
                    pos = {x, y}

                    if Map.has_key?(orig_coords, pos) do
                      coords
                    else
                      prev_pos = {rem(x, width), rem(y, height)}
                      prev_risk = Map.get(coords, prev_pos)
                      new_risk = rem(prev_risk + floor(x / width) + floor(y / width) - 1, 9) + 1
                      #IO.inspect({pos, prev_pos, prev_risk, new_risk})
                      Map.put(coords, pos, new_risk)
                    end
                  end
                )
           end
         )
  end

  defp lowest_risk(risk_map, max_coords, risk_at_position) do
    new_risk_at_position =
      risk_map
      |> Enum.reduce(
           risk_at_position,
           fn {{x, y} = position, risk}, rap ->

             [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]
             |> Enum.reduce(
                  rap,
                  fn {dx, dy}, rap ->
                    prev_pos = {x + dx, y + dy}

                    case Map.get(rap, prev_pos) do
                      nil -> rap
                      prev_risk ->
                        Map.update(rap, position, risk + prev_risk, fn ex -> min(ex, risk + prev_risk) end)
                    end
                  end
                )
           end
         )

    IO.inspect(Map.size(new_risk_at_position))

    if new_risk_at_position == risk_at_position do
      new_risk_at_position
    else
      lowest_risk(risk_map, max_coords, new_risk_at_position)
    end
  end
end
