defmodule Day03P1 do

  def solve(filename) do
    {head, _} =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.split(-1)

    [bits, amount] = head
    |> Enum.reduce([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0], &find_most_common_bit/2)

    bits = bits
    |> Enum.map(fn count -> if count > amount / 2 do 1 else 0 end end)

    first = bits
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {binary, position}, sum -> sum + binary * :math.pow(2, position) end)

    second = bits
            |> Enum.reverse()
            |> Enum.with_index()
            |> Enum.reduce(0, fn {binary, position}, sum -> sum + (1-binary) * :math.pow(2, position) end)

    first * second
  end

  defp find_most_common_bit(value, [bits, amount]) do

    bits = value
    |> to_charlist()
    |> Enum.zip(bits)
    |> Enum.map(&increase/1)

    [bits, amount + 1]
  end

  defp increase({char, count}) do
    case char do
      49 -> count + 1
      48 -> count
    end
  end
end
