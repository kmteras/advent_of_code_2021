defmodule Day02P2 do

  def run(filename) do
    {head, tail} = File.read!(filename)
    |> String.split("\n")
    |> Enum.split(-1)

    IO.inspect(head)

    [x, y, aim] = Enum.reduce(head, [0, 0, 0], &calculate_coordinate/2)
    |> IO.inspect()
    IO.puts(x * y)
  end

  def calculate_coordinate(value, [x, y, aim]) do
    [direction, amount_str] = String.split(value)
    amount = String.to_integer(amount_str)

    IO.inspect([x, y])

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
