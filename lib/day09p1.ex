defmodule Day09P1 do

  def solve(filename) do
    points =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(
           fn line ->
             line
             |> Enum.map(&String.to_integer/1) end
         )

    points
    |> Enum.with_index()
    |> Enum.reduce(0, fn {line, y}, sum -> sum + lowpoints(points, line, y) end)
  end

  def lowpoints(points, line, y) do
    line
    |> Enum.with_index()
    |> Enum.reduce(0, fn {point, x}, sum -> sum + lowpoint(points, x, y, point) end)
  end

  def lowpoint(points, x, y, point) do
    left = if x - 1 >= 0 do
      points
      |> Enum.at(y)
      |> Enum.at(x - 1)
    else
      10
    end

    right = if x + 1 < length(
      points
      |> Enum.at(0)
    ) do
      points
      |> Enum.at(y)
      |> Enum.at(x + 1)
    else
      10
    end

    up = if y - 1 >= 0 do
      points
      |> Enum.at(y - 1)
      |> Enum.at(x)
    else
      10
    end

    down = if y + 1 < length(points) do
      points
      |> Enum.at(y + 1)
      |> Enum.at(x)
    else
      10
    end

    if left > point && right > point && up > point && down > point do
      point + 1
    else
      0
    end
  end
end
