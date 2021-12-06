defmodule Day06P2 do

  # 7 days, + 2 days

  def solve(filename) do
    tick_map = 0..8
               |> Map.new(fn tick -> {tick, 0} end)

    File.read!(filename)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(
         tick_map,
         fn timer, tick_map -> Map.update(tick_map, timer, 0, fn ex -> ex + 1 end) end
       )
    |> tick()
  end

  defp tick(timers, days \\ 0) do
    if days == 256 do
      Map.values(timers)
      |> Enum.reduce(0, fn v, s -> v + s end)
    else
      %{
        0 => Map.get(timers, 1, 0),
        1 => Map.get(timers, 2, 0),
        2 => Map.get(timers, 3, 0),
        3 => Map.get(timers, 4, 0),
        4 => Map.get(timers, 5, 0),
        5 => Map.get(timers, 6, 0),
        6 => Map.get(timers, 7, 0) + Map.get(timers, 0, 0),
        7 => Map.get(timers, 8, 0),
        8 => Map.get(timers, 0, 0)
      }
      |> tick(days + 1)
    end
  end
end
