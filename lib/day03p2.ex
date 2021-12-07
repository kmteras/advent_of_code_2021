defmodule Day03P2 do

  def solve(filename) do
    {head, _} =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.split(-1)

    most = pass(head, 0)

    least = pass_least(head, 0)

    most * least
  end

  defp pass(head, index) do
    bits = most_common(head)

    most_common =
      bits
      |> Enum.at(index)
      |> to_string()

    new_head = head
               |> Enum.filter(
                    fn bits ->
                      bits
                      |> String.at(index)
                      == most_common
                    end
                  )

    if length(new_head) > 1 do
      pass(new_head, index + 1)
    else
      bits_to_num(new_head)
    end
  end

  defp pass_least(head, index) do
    bits = least_common(head)

    most_common =
      bits
      |> Enum.at(index)
      |> to_string()

    new_head = head
               |> Enum.filter(
                    fn bits ->
                      bits
                      |> String.at(index)
                      == most_common
                    end
                  )

    if length(new_head) > 1 do
      pass_least(new_head, index + 1)
    else
      bits_to_num(new_head)
    end
  end

  defp bits_to_num([bits]) do
    bits
    |> to_charlist()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {binary, position}, sum -> sum + (binary - 48) * :math.pow(2, position) end)
  end

  defp most_common(head) do
    [bits, amount] =
      head
      |> Enum.reduce([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0], &find_most_common_bit/2)

    bits
    |> Enum.map(
         fn count ->
           if count >= amount / 2 do
             1
           else
             0
           end
         end
       )
  end

  defp least_common(head) do
    [bits, amount] =
      head
      |> Enum.reduce([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0], &find_most_common_bit/2)

    bits
    |> Enum.map(
         fn count ->
           if count >= amount / 2 do
             0
           else
             1
           end
         end
       )
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
