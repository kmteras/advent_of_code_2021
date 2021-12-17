defmodule Day17P1 do

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
         -1000000000000,
         fn x, m ->
           nm =
             -200..200
             |> Enum.reduce(
                  -100000000000000,
                  fn y, m ->
                    max(m, step({0, 0}, {x, y}, {{x1, x2}, {y1, y2}}))
                  end
                )
           max(m, nm)
         end
       )
  end

  defp step({x, y} = p, {dx, dy} = v, {{x1, x2}, {y1, y2}} = a, hy \\ -10000000000000) do
    p = {x, y} = {x + dx, y}
    p = {x, y} = {x, y + dy}

    if is_in_area(p, a) do
      max(y, hy)
    else
      v = {toward_zero(dx), dy - 1}

      if x > x1 && x > x2 || y < y1 && y < y2 do
        -10000000000000000
      else
        step(p, v, a, max(y, hy))
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
