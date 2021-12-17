defmodule Day17P2 do

  def solve(filename) do
    [_, _, xi, yi]
    = File.read!(filename)
      |> String.trim()
      |> String.split(" ")

    [x1, x2] =
      xi
      |> String.replace(",", "")
      |> String.split("=")
      |> Enum.at(1)
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)

    [y1, y2] =
      yi
      |> String.split("=")
      |> Enum.at(1)
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)


    -200..200
    |> Enum.reduce(
         MapSet.new([]),
         fn x, s ->
           -200..200
           |> Enum.reduce(
                MapSet.new([]),
                fn y, s ->
                  case step({0, 0}, {x, y}, {{x1, x2}, {y1, y2}}) do
                    nil -> s
                    v -> MapSet.union(s, MapSet.new([{x, y}]))
                  end
                end
              )
           |> MapSet.union(s)
         end
       )
    |> MapSet.size()
  end

  defp step({x, y} = p, {dx, dy} = v, {{x1, x2}, {y1, y2}} = a) do
    p = {x, y} = {x + dx, y}

    p = {x, y} = {x, y + dy}

    if is_in_area(p, a) do
      v
    else
      v = {toward_zero(dx), dy - 1}

      if x > x1 && x > x2 || y < y1 && y < y2 do
        nil
      else
        step(p, v, a)
      end
    end
  end

  defp is_in_area({x, y}, {{x1, x2}, {y1, y2}}) do
    x >= x1 && x <= x2 && y >= y1 && y <= y2
  end

  defp toward_zero(x) do
    cond do
      x > 0 -> x - 1
      x < 0 -> x + 1
      x == 0 -> x
    end
  end
end
