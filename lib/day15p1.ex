defmodule Day15P1 do

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

    max_coords =
      coords
      |> Enum.reduce(
           {0, 0},
           fn {{x, y}, value}, {px, py} = prev ->
             if x >= px && y >= py do
               {x, y}
             else
               prev
             end
           end
         )
      |> IO.inspect()

    rap = lowest_risk(coords, max_coords, %{{0, 0} => 0})
    Map.get(rap, max_coords)
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
                    if Map.has_key?(risk_at_position, prev_pos) do
                      prev_risk = Map.get(risk_at_position, prev_pos)
                      Map.update(rap, position, risk + prev_risk, fn ex -> min(ex, risk + prev_risk) end)
                    else
                      rap
                    end
                  end
                )
           end
         )

    if risk_at_position == new_risk_at_position do
      new_risk_at_position
    else
      lowest_risk(risk_map, max_coords, new_risk_at_position)
    end
  end
end
