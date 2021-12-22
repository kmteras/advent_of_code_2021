defmodule Day22P1 do

  def solve(filename) do
    ins
    = File.read!(filename)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(&{Enum.at(&1, 0), String.split(Enum.at(&1, 1), ",")})

    Enum.reduce(ins, %{}, &turn/2)
    |> Map.values()
    |> Enum.filter(fn v -> v == "on" end)
    |> Enum.count()
  end

  defp turn({way, [x, y, z]}, coords) do
    x = String.slice(x, 2..-1)
    [x1, x2] = String.split(x, "..")
    y = String.slice(y, 2..-1)
    [y1, y2] = String.split(y, "..")
    z = String.slice(z, 2..-1)
    [z1, z2] = String.split(z, "..")

    x1 = String.to_integer(x1)
    x2 = String.to_integer(x2)
    y1 = String.to_integer(y1)
    y2 = String.to_integer(y2)
    z1 = String.to_integer(z1)
    z2 = String.to_integer(z2)

    IO.inspect({way, {x, y, z}})
    IO.inspect(Map.size(coords))

    limit(x1)..limit(x2)
    |> IO.inspect()
    |> Enum.reduce(
         coords,
         fn x, coords ->
           limit(y1)..limit(y2)
           |> Enum.reduce(
                coords,
                fn y, coords ->
                  limit(z1)..limit(z2)
                  |> Enum.reduce(
                       coords,
                       fn z, coords ->
                         if abs(x) != 51 && abs(y) != 51 && abs(z) != 51 do
                          Map.update(coords, {x, y, z}, way, fn _ -> way end)
                         else
                           coords
                         end

                       end
                     )
                end
              )
         end
       )
  end

  def limit(v) do
    max(min(v, 51), -51)
  end
end
