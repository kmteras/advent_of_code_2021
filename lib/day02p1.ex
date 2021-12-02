defmodule Day02P1 do

  def run(filename) do
    {head, tail} = File.read!(filename)
    |> String.split("\n")
    |> Enum.split(-1)

    IO.inspect(head)

    [x, y] = Enum.reduce(head, [0, 0], &calculate_coordinate/2)
    |> IO.inspect()
    IO.puts(x * y)
  end

  def calculate_coordinate(value, [x, y]) do
    [direction, amount_str] = String.split(value)
    amount = String.to_integer(amount_str)

    IO.inspect([x, y])

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
