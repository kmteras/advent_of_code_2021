defmodule Day02P1 do

  def solve(filename) do
    {head, _} =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.split(-1)

    [x, y] = Enum.reduce(head, [0, 0], &calculate_coordinate/2)
    x * y
  end

  defp calculate_coordinate(value, [x, y]) do
    [direction, amount_str] = String.split(value)
    amount = String.to_integer(amount_str)

    case direction do
      "forward" ->
        [x + amount, y]
      "down" ->
        [x, y + amount]
      "up" ->
        [x, y - amount]
    end
  end
end
