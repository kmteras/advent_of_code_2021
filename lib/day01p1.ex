defmodule Day01P1 do

  def run(filename) do
    File.read!(filename)
    |> String.split()
    |> Enum.reduce([0, 0], &more_than_previous/2)
    |> IO.inspect()
  end

  def more_than_previous(str_value, [total, previous]) do
    {value, _} = Integer.parse(str_value)

    IO.inspect([value, previous, total])

    if value > previous do
      [total + 1, value]
    else
      [total, value]
    end
  end
end
