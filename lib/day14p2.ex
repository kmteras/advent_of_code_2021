defmodule Day14P2 do

  def solve(filename) do
    [template, rules] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n\n")

    first_letter = String.first(template)
    last_letter = String.last(template)

    {pair_map, _} =
      template
      |> String.graphemes()
      |> Enum.reduce(
           {%{}, nil},
           fn letter, {map, prev_letter} ->
             if prev_letter == nil do
               {map, letter}
             else
               {Map.update(map, prev_letter <> letter, 1, &(&1 + 1)), letter}
             end
           end
         )

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(
           &String.split(&1, " -> ")
            |> List.to_tuple()
         )
      |> Map.new()

    counts =
      pair_map
      |> insert(rules)
      |> Enum.reduce(
           %{},
           fn {letters, count}, map ->
             map
             |> Map.update(String.first(letters), count, &(&1 + count))
             |> Map.update(String.last(letters), count, &(&1 + count))
           end
         )
      |> Map.update!(first_letter, &(&1 + 1))
      |> Map.update!(last_letter, &(&1 + 1))
      |> Map.map(&(elem(&1, 1) / 2))
      |> Map.values()

    min_count = Enum.min(counts)
    max_count = Enum.max(counts)

    max_count - min_count
  end

  defp insert(pair_map, rules, step \\ 0) do
    if step == 40 do
      pair_map
    else
      pair_map
      |> Enum.reduce(
           pair_map,
           fn {pair, count}, pair_map ->
             if Map.has_key?(rules, pair) && count > 0 do
               new_letter = Map.get(rules, pair)
               left_pair = String.first(pair) <> new_letter
               right_pair = new_letter <> String.last(pair)

               pair_map
               |> Map.update(pair, 0, &(&1 - count))
               |> Map.update(left_pair, count, &(&1 + count))
               |> Map.update(right_pair, count, &(&1 + count))
             else
               pair_map
             end
           end
         )
      |> insert(rules, step + 1)
    end
  end
end
