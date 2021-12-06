defmodule Day06P1 do

  # 7 days, + 2 days

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> tick()
  end

  defp tick(timers, days \\ 0) do
    if days == 80 do
      length(timers)
    else
      new_timers =
      timers
      |> Enum.filter(fn timer -> timer == 0 end)
      |> Enum.map(fn _ -> 8 end)

      timers = timers
      |> Enum.map(
           fn timer ->
             if timer > 0 do
               timer - 1
             else
               6
             end
           end
         )

      timers ++ new_timers\
      |> tick(days + 1)
    end
  end
end
