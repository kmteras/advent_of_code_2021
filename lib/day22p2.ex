defmodule Day22P2 do

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&{Enum.at(&1, 0), String.split(Enum.at(&1, 1), ",")})
    |> Enum.reduce(%{}, &turn/2)
    |> IO.inspect()
    |> Enum.map(fn {coords, sign} -> size(coords) * sign end)
    |> Enum.sum()
  end

  defp turn({way, [x, y, z]}, coords) do
    {{lx1, lx2}, {ly1, ly2}, {lz1, lz2}} = cube = parse_coords(x, y, z)

    IO.inspect({way, cube})

    sign = if way == "on", do: 1, else: -1

    changes =
      Enum.reduce(
        coords,
        %{},
        fn {colliding_cube, colliding_sign}, changes ->
          intersection = colliding(cube, colliding_cube)

          if intersection do
            Map.update(changes, intersection, -colliding_sign, fn ex -> ex - colliding_sign end)
          else
            changes
          end
        end
      )

    case sign do
      1 -> Map.update(coords, cube, sign, fn ex -> ex + sign end)
      -1 -> coords
    end
    |> Map.merge(changes, fn _, ex1, ex2 -> ex1 + ex2 end)
  end

  defp colliding({{lx1, lx2}, {ly1, ly2}, {lz1, lz2}}, {{rx1, rx2}, {ry1, ry2}, {rz1, rz2}}) do
    xd = if max(lx1, rx1) <= min(lx2, rx2) do
      {max(lx1, rx1), min(lx2, rx2)}
    end

    yd = if max(ly1, ry1) <= min(ly2, ry2) do
      {max(ly1, ry1), min(ly2, ry2)}
    end

    zd = if max(lz1, rz1) <= min(lz2, rz2) do
      {max(lz1, rz1), min(lz2, rz2)}
    end

    if xd && yd && zd do
      {xd, yd, zd}
    end
  end

  defp parse_coords(x, y, z) do
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
    {{x1, x2 + 1}, {y1, y2 + 1}, {z1, z2 + 1}}
  end

  defp size({{x1, x2}, {y1, y2}, {z1, z2}}) do
    (x2 - x1) * (y2 - y1) * (z2 - z1)
  end
end
