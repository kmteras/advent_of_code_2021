defmodule Day08P2 do

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, " | ") end)
    |> Enum.map(
         fn [p1, p2] ->
           [String.split(p1, " "), String.split(p2, " ")]
         end
       )
    |> Enum.reduce(0, fn splits, sum -> sum + splits_sum(splits) end)
  end

  def splits_sum([first, second]) do
    values = find_possibilities(first)

    second
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(
         0,
         fn n, sum ->
           sum + get_number_value(n, values)
         end
       )
  end

  def find_possibilities(numbers) do
    [one, seven, four, eighth] =
      numbers
      |> Enum.filter(fn number -> Enum.member?([2, 4, 3, 7], String.length(number)) end)
      |> Enum.map(&String.graphemes/1)
      |> Enum.sort(fn left, right -> length(left) <= length(right) end)

    other_numbers =
      numbers
      |> Enum.filter(fn number -> !Enum.member?([2, 4, 3, 7], String.length(number)) end)
      |> Enum.map(&String.graphemes/1)
      |> Enum.sort(fn left, right -> length(left) <= length(right) end)

    values = Map.put(
      %{},
      0,
      not_common(one, seven)
      |> Enum.at(0)
    )

    [nine] = Enum.filter(other_numbers, fn number -> contains_same_as(number, four) && length(number) == 6 end)

    values =
      values
      |> Map.put(
           6,
           not_common(nine, four)
           |> not_common([Map.get(values, 0)])
           |> Enum.at(0)
         )
      |> Map.put(
           4,
           not_common(eighth, nine)
           |> Enum.at(0)
         )

    [three] = Enum.filter(other_numbers, fn number -> contains_same_as(number, seven) && length(number) == 5 end)

    values = Map.put(
      values,
      3,
      not_common(three, seven)
      |> not_common([Map.get(values, 6)])
      |> Enum.at(0)
    )

    [zero] = Enum.filter(other_numbers, fn number -> not_common(number, eighth) == [Map.get(values, 3)] end)

    [five] = Enum.filter(
      other_numbers,
      fn number ->
        not_common(number, eighth)
        |> Enum.member?(Map.get(values, 4)) && length(common(number, one)) == 1 end
    )

    [six] = Enum.filter(
      other_numbers,
      fn number -> length(not_common(number, eighth)) == 1 && number != nine && number != zero end
    )

    [two] = Enum.filter(
      other_numbers,
      fn number -> number != zero
                   && number != three
                   && number != five
                   && number != six
                   && number != nine
      end
    )

    values = Map.put(
      values,
      2,
      not_common(five, eighth)
      |> not_common([Map.get(values, 4)])
      |> Enum.at(0)
    )
    values = Map.put(
      values,
      5,
      two
      |> not_common(eighth)
      |> common(one)
      |> Enum.at(0)
    )
    Map.put(
      values,
      1,
      two
      |> not_common(eighth)
      |> not_common([Map.get(values, 5)])
      |> Enum.at(0)
    )
  end

  def common(left, right) do
    left
    |> Enum.filter(fn el -> Enum.member?(right, el) end)
  end

  def not_common(left, right) do
    l =
      left
      |> Enum.filter(fn el -> !Enum.member?(right, el) end)
    r =
      right
      |> Enum.filter(fn el -> !Enum.member?(left, el) end)
    l ++ r
  end

  def contains_same_as(container, number) do
    Enum.sort(common(container, number)) == Enum.sort(number)
  end

  def contains(container, letter) do
    Enum.member?(container, letter)
  end

  def get_number_value({number, index}, cache) do
    get_number(number, cache) * :math.pow(10, index)
  end

  def get_number(number, cache) do
    grap = number
           |> String.graphemes()
    keys = cache
           |> Map.filter(fn {_key, val} -> Enum.member?(grap, val) end)
           |> Map.keys()

    case keys do
      [0, 1, 2, 4, 5, 6] -> 0
      [2, 5] -> 1
      [0, 2, 3, 4, 6] -> 2
      [0, 2, 3, 5, 6] -> 3
      [1, 2, 3, 5] -> 4
      [0, 1, 3, 5, 6] -> 5
      [0, 1, 3, 4, 5, 6] -> 6
      [0, 2, 5] -> 7
      [0, 1, 2, 3, 4, 5, 6] -> 8
      [0, 1, 2, 3, 5, 6] -> 9
    end
  end
end
