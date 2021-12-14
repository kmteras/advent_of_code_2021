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
               {Map.update(map, prev_letter <> letter, 1, fn ex -> ex + 1 end), letter}
             end
           end
         )

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(
           fn rule ->
             [first, second] = String.split(rule, " -> ")
             {first, second}
           end
         )
      |> Map.new()

    {pair_map, first, last} = insert(pair_map, rules, String.slice(template, 0..1), String.slice(template, -2..-1))

    count =
      pair_map
      |> Enum.reduce(
           %{},
           fn {letters, count}, map ->

             map = if letters == first do
               Map.update(map, String.first(letters), count, fn ex -> ex + count end)
             else
               Map.update(map, String.first(letters), count, fn ex -> ex + count end)
             end

             map = if letters == last do
               Map.update(map, String.last(letters), count, fn ex -> ex + count end)
             else
               Map.update(map, String.last(letters), count, fn ex -> ex + count end)
             end
           end
         )
      |> IO.inspect()

    min_count =
      count
      |> Enum.reduce(1000000000000000000000, fn {letter, count}, min_count ->
        if letter == first_letter || letter == last_letter do
          min((count + 1) / 2, min_count)
        else
          min(count / 2, min_count)
        end
      end)

    max_count =
      count
      |> Enum.reduce(0, fn {letter, count}, max_count ->
        if letter == first_letter || letter == last_letter do
          max((count + 1) / 2, max_count)
        else
          max(count / 2, max_count)
        end
      end)

    max_count - min_count
  end

  defp insert(pair_map, rules, first, last, step \\ 0) do
    if step == 40 do
      {pair_map, first, last}
    else
      {pair_map, first, last} =
        pair_map
        |> Enum.reduce(
             {pair_map, first, last},
             fn {pair, count}, {pair_map, first, last} ->
               #IO.inspect({pair, pair_map, Map.has_key?(rules, pair)})

               if Map.has_key?(rules, pair) && count > 0 do
                 new_letter = Map.get(rules, pair)
                 left_pair = String.first(pair) <> new_letter
                 right_pair = new_letter <> String.last(pair)

                 pair_map =
                   pair_map
                   |> Map.update(pair, 0, fn ex -> ex - count end)
                   |> Map.update(left_pair, count, fn ex -> ex + count end)
                   |> Map.update(right_pair, count, fn ex -> ex + count end)

                 first = if first == pair do
                   left_pair
                 else
                   first
                 end

                 last = if last == pair do
                   right_pair
                 else
                   last
                 end

                 {pair_map, first, last}
               else
                 {pair_map, first, last}
               end
             end
           )
        |> IO.inspect()
      insert(pair_map, rules, first, last, step + 1)
    end
  end
end
