defmodule Day14P1 do

  def solve(filename) do
    [template, rules] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n\n")

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

    counts =
      template
      |> String.graphemes()
      |> insert(rules)
      |> Enum.reduce(%{}, fn letter, map -> Map.update(map, letter, 1, fn ex -> ex + 1 end) end)

    min_count = Enum.reduce(counts, 100000000, fn {_, count}, min_count -> min(count, min_count) end)
    max_count = Enum.reduce(counts, 0, fn {_, count}, max_count -> max(count, max_count) end)

    max_count - min_count
  end

  defp insert(template, rules, step \\ 0) do
    if step == 10 do
      template
    else
      {template, _} =
        Enum.reduce(
          template,
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
