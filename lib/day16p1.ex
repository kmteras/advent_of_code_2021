defmodule Day16P1 do

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(
         &hex_to_binary(&1)
          |> String.graphemes()
       )
    |> Enum.flat_map(fn x -> x end)
    |> parse_input()
  end

  defp parse_input(input) do
    if MapSet.new(input) == MapSet.new(["0"]) do
      0
    else
      IO.inspect(%{input: input})

      {version_chars, input} = Enum.split(input, 3)
      {type_chars, input} = Enum.split(input, 3)

      version = binary_to_int(version_chars)
      type = binary_to_int(type_chars)

      IO.inspect(%{version: version, type: type, input: input})

      {input, sum} = case type do
        4 ->
          {number, input} = parse_value(input)
          number =
            number
            |> Enum.flat_map(fn x -> x end)
            |> binary_to_int()
          IO.inspect({"Number", number})
          {input, 0}
        _ ->
          {number, input} = parse_operation(input)
      end

      version = version + sum

      if input == [] do
        version
      else
        version + parse_input(input)
      end
    end


  end

  defp parse_value(input, bits_read \\ 11) do
    {value_chars, input} = Enum.split(input, 5)
    {[prefix], real_value_chars} = Enum.split(value_chars, 1)
    case prefix do
      "1" ->
        {values, input} = parse_value(input, bits_read + 5)
        {[real_value_chars] ++ values, input}
      "0" ->
        {[real_value_chars], input}
    end
  end

  defp parse_operation(input) do
    {[length], input} = Enum.split(input, 1)

    split_at = case length do
      "0" -> 15
      "1" -> 11
    end

    {l, input} = Enum.split(input, split_at)
    bits = binary_to_int(l)

    IO.inspect(%{op_type: length, c: bits})

    case length do
      "0" ->
        {sub_packets, input} = Enum.split(input, bits)
        IO.inspect({"Info", sub_packets, input})
        {input, parse_input(sub_packets)}
      "1" ->
        IO.inspect(input)
        {[], parse_input(input)}
    end
  end

  defp hex_to_binary(hex) do
    %{
      "0" => "0000",
      "1" => "0001",
      "2" => "0010",
      "3" => "0011",
      "4" => "0100",
      "5" => "0101",
      "6" => "0110",
      "7" => "0111",
      "8" => "1000",
      "9" => "1001",
      "A" => "1010",
      "B" => "1011",
      "C" => "1100",
      "D" => "1101",
      "E" => "1110",
      "F" => "1111",

    }
    |> Map.get(hex)
  end

  defp binary_to_int(bits) do
    bits
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {binary, position}, sum -> sum + String.to_integer(binary) * :math.pow(2, position) end)
    |> floor()
  end
end
