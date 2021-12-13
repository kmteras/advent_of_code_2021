defmodule Day13P1 do

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

    fold(coords, Enum.at(folds, 0))
    |> MapSet.size()
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
end
