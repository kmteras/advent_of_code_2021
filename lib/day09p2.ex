defmodule Day09P2 do

  def solve(filename) do
    points =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(
           fn line ->
             line
             |> Enum.map(&String.to_integer/1)
           end
         )

    lows =
      points
      |> Enum.with_index()
      |> Enum.reduce([], fn {line, y}, lows -> lows ++ lowpoints(points, line, y) end)

    lows
    |> Enum.map(fn low -> basins(points, low) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn value, sum -> value * sum end)
  end

  def lowpoints(points, line, y) do
    line
    |> Enum.with_index()
    |> Enum.reduce([], fn {point, x}, lows -> lowpoint(points, x, y, point, lows) end)
  end

  def lowpoint(points, x, y, point, lows) do
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
      lows ++ [{x, y}]
    else
      lows
    end
  end

  def basins(points, low) do
    {basin_points, _} = get_basins(points, low, MapSet.new([]))
    basin_points
    |> MapSet.size()
  end

  def get_basins(points, {x, y} = low, searched) do
    if MapSet.member?(searched, low) || value_at(points, x, y) == 9 do
      {MapSet.new([]), searched}
    else
      low_value = value_at(points, x, y)
      basin_points = MapSet.new([low])

      searched = MapSet.put(searched, low)

      # Left
      {new_basin_points, searched} = if x - 1 >= 0 && value_at(points, x - 1, y) > low_value do
        get_basins(points, {x - 1, y}, searched)
      else
        {basin_points, searched}
      end

      basin_points =
        basin_points
        |> MapSet.union(new_basin_points)

      # Right
      {new_basin_points, searched} = if x + 1 < length(Enum.at(points, 0)) && value_at(points,  x + 1, y) > low_value do
        get_basins(points, {x + 1, y}, searched)
      else
        {basin_points, searched}
      end

      basin_points =
        basin_points
        |> MapSet.union(new_basin_points)

      # Up
      {new_basin_points, searched} = if y - 1 >= 0 && value_at(points,  x, y - 1) > low_value do
        get_basins(points, {x, y - 1}, searched)
      else
        {basin_points, searched}
      end

      basin_points =
        basin_points
        |> MapSet.union(new_basin_points)

      # Down
      {new_basin_points, searched} = if y + 1 < length(points) && value_at(points,  x, y + 1) > low_value do
        get_basins(points, {x, y + 1}, searched)
      else
        {basin_points, searched}
      end

      basin_points =
        basin_points
        |> MapSet.union(new_basin_points)

      {basin_points, searched}
    end
  end

  def value_at(points, x, y) do
    Enum.at(Enum.at(points, y), x)
  end
end
