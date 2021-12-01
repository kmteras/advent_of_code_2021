defmodule Day01P2 do

  def run(filename) do
    {head, tail} = File.read!(filename)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.split(3)

    tail
    |> Enum.reduce([0, head], &more_than_previous/2)
    |> IO.inspect()
  end

  def more_than_previous(value, [total, [first, second, third]]) do
    previous = first + second + third
    current = value + second + third

    if current > previous do
      [total + 1, [second, third, value]]
    else
      [total, [second, third, value]]
    end
  end
end
