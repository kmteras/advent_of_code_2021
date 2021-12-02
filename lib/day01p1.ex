defmodule Day01P1 do

  def solve(filename) do
    [more, _] =
      File.read!(filename)
      |> String.split()
      |> Enum.reduce([0, 0], &more_than_previous/2)
    more
  end

  defp more_than_previous(str_value, [total, previous]) do
    {value, _} = Integer.parse(str_value)

    if value > previous do
      [total + 1, value]
    else
      [total, value]
    end
  end
end
