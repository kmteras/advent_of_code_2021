defmodule Day13P2 do

  def solve(filename) do
    [coords, folds] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n\n")

    coords =
      coords
      |> String.split("\n")
      |> Enum.map(
           fn line ->
             [x, y] = String.split(line, ",")
             {String.to_integer(x), String.to_integer(y)}
           end
         )
      |> MapSet.new()

    folds =
      folds
      |> String.split("\n")
      |> Enum.map(
           fn line ->
             String.split(line, " ")
             |> Enum.at(2)
           end
         )

    letter_coords =
      folds
      |> Enum.reduce(coords, fn fold, coords -> fold(coords, fold) end)

    IO.puts(coords_to_string(letter_coords))
  end

  def fold(coords, fold) do
    case String.split(fold, "=") do
      ["x", foldX] ->
        foldX = String.to_integer(foldX)
        coords
        |> Enum.map(
             fn {x, y} ->
               if x > foldX do
                 {foldX * 2 - x, y}
               else
                 {x, y}
               end
             end
           )
        |> MapSet.new()
      ["y", foldY] ->
        foldY = String.to_integer(foldY)
        coords
        |> Enum.map(
             fn {x, y} ->
               if y > foldY do
                 {x, foldY * 2 - y}
               else
                 {x, y}
               end
             end
           )
        |> MapSet.new()
    end
  end

  def coords_to_string(letter_coords) do
    max_x =
      letter_coords
      |> Enum.reduce(
           0,
           fn {x, _}, max ->
             if x > max do
               x
             else
               max
             end
           end
         )
    max_y =
      letter_coords
      |> Enum.reduce(
           0,
           fn {_, y}, max ->
             if y > max do
               y
             else
               max
             end
           end
         )

    0..max_y
    |> Enum.map(
         fn y ->
           0..max_x
           |> Enum.map(
                fn x ->
                  if MapSet.member?(letter_coords, {x, y}) do
                    "X"
                  else
                    " "
                  end
                end
              )
           |> Enum.join("")
         end
       )
    |> Enum.join("\n")
  end
end
