defmodule Day20P1 do

  def solve(filename) do
    [algo, image] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n\n")

    pixels =
      image
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
                  fn {pixel, x}, map -> Map.put(map, {x, y}, pixel) end
                )
             |> Map.merge(map)
           end
         )

    second_default = String.at(algo, 0)

    pixels
    |> enhance(algo)
    |> enhance(algo, second_default)
    |> Enum.filter(fn {{x, y}, v} -> v == "#" end)
    |> Enum.count()
  end

  defp enhance(pixels, algo, default \\ ".", b \\ 1) do
    {{min_x, _}, _} = Enum.min_by(pixels, fn {{x, _}, _} -> x end)
    {{max_x, _}, _} = Enum.max_by(pixels, fn {{x, _}, _} -> x end)
    {{_, min_y}, _} = Enum.min_by(pixels, fn {{_, y}, _} -> y end)
    {{_, max_y}, _} = Enum.max_by(pixels, fn {{_, y}, _} -> y end)

    (min_x - b)..(max_x + b)
    |> Enum.reduce(
         pixels,
         fn x, p ->
           (min_y - b)..(max_y + b)
           |> Enum.reduce(
                p,
                fn y, p ->
                  pixel = enhance_pixel(pixels, algo, {x, y}, default)
                  Map.put(p, {x, y}, pixel)
                end
              )
         end
       )
  end

  defp enhance_pixel(pixels, algo, {x, y}, default) do
    [
      {-1, -1},
      {0, -1},
      {1, -1},

      {-1, 0},
      {0, 0},
      {1, 0},

      {-1, 1},
      {0, 1},
      {1, 1}
    ]
    |> Enum.map(fn {xd, yd} -> {x + xd, y + yd} end)
    |> Enum.map(fn coords -> Map.get(pixels, coords, default) end)
    |> decode(algo, {x, y})
  end

  defp decode(string, algo, {x, y}) do
    decimal = binary_to_int(string)
    #IO.inspect({string, decimal, String.at(algo, decimal)})
    String.at(algo, decimal)
  end

  defp binary_to_int(bits) do
    bits
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(
         0,
         fn {binary, position}, sum ->
           one_zero = if binary == "#" do
             1
           else
             0
           end
           sum + one_zero * :math.pow(2, position)
         end
       )
    |> floor()
  end
end
