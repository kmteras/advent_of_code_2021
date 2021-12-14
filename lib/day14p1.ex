defmodule Day14P1 do

  def solve(filename) do
    [template, rules] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n\n")

    template = template
               |> String.graphemes()

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

    count =
      insert(template, rules)
      |> Enum.reduce(%{}, fn letter, map -> Map.update(map, letter, 1, fn ex -> ex + 1 end) end)

    min_count =
      count
      |> Enum.reduce(100000000, fn {letter, count}, min_count -> min(count, min_count) end)

    max_count =
      count
      |> Enum.reduce(0, fn {letter, count}, max_count -> max(count, max_count) end)

    max_count - min_count
  end

  defp insert(template, rules, step \\ 0) do
    if step == 10 do
      template
    else
      {template, _} =
        template
        |> Enum.reduce(
             {[], nil},
             fn letter, {template, prev_letter} ->
               if prev_letter != nil && Map.has_key?(rules, prev_letter <> letter) do
                 {template ++ [Map.get(rules, prev_letter <> letter), letter], letter}
               else
                 {template ++ [letter], letter}
               end
             end
           )
      insert(template, rules, step + 1)
    end
  end
end
