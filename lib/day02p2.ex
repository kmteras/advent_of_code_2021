defmodule Day02P2 do

  def solve(filename) do
    {head, _} =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.split(-1)

    [x, y, _aim] = Enum.reduce(head, [0, 0, 0], &calculate_coordinate/2)
    x * y
  end

  defp calculate_coordinate(value, [x, y, aim]) do
    [direction, amount_str] = String.split(value)
    amount = String.to_integer(amount_str)

    case direction do
      "down" ->
        [x, y, aim + amount]

      "up" ->
        [x, y, aim - amount]

      "forward" ->
        [x + amount, y + aim * amount, aim]
    end
  end
end
