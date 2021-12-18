defmodule Day18P1 do

  def solve(filename) do
    test()

    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(&addition/2)
    |> IO.inspect()
    |> magnitude()
  end

  defp parse_line(line) do
    {first, line} = String.split_at(line, 1)
    case first do
      "[" ->
        {cp, ep} = find_markers(line)
        {left, right}
        = line
          |> String.slice(0..ep)
          |> String.split_at(cp)
        right = String.slice(right, 1..-1)
        {parse_line(left), parse_line(right)}
      number -> String.to_integer(number)
    end
  end

  defp find_markers(line, at \\ 0, depth \\ 0, comma \\ nil) do
    {first, line} = String.split_at(line, 1)
    case first do
      "[" -> find_markers(line, at + 1, depth + 1, comma)
      "]" ->
        if depth == 0 do
          {comma, at - 1}
        else
          find_markers(line, at + 1, depth - 1, comma)
        end
      "," ->
        if depth == 0 do
          find_markers(line, at + 1, depth, at)
        else
          find_markers(line, at + 1, depth, comma)
        end
      _ -> find_markers(line, at + 1, depth, comma)
    end
  end

  defp reduce(numbers) do
    new_numbers = reduce_step(numbers)
    if new_numbers == numbers do
      new_numbers
    else
      reduce(new_numbers)
    end
  end

  defp reduce_step(numbers) do
    numbers = case find_to_explode(numbers) do
      nil ->
        case find_to_split(numbers) do
          nil -> numbers
          steps -> go_split(numbers, steps)
        end
      steps ->
        {numbers, _} = explode2(numbers, steps)
        numbers
    end
  end

  defp find_to_explode(numbers, depth \\ 1, steps \\ [])

  defp find_to_explode({left, right} = numbers, depth, steps) do
    if depth > 4 do
      steps
    else
      left_find = find_to_explode(left, depth + 1, steps ++ [:left])
      if left_find == nil do
        find_to_explode(right, depth + 1, steps ++ [:right])
      else
        left_find
      end
    end
  end

  defp find_to_explode(_number, _depth, _steps), do: nil

  defp find_to_split(numbers, steps \\ [])

  defp find_to_split({left, right} = numbers, steps) do
    left_find = find_to_split(left, steps ++ [:left])
    if left_find == nil do
      find_to_split(right, steps ++ [:right])
    else
      left_find
    end
  end

  defp find_to_split(number, steps) do
    if number >= 10 do
      steps
    else
      nil
    end
  end

  defp go_split(number, []) do
    split(number)
  end

  defp go_split({left, right} = numbers, steps) do
    {[step], steps} = Enum.split(steps, 1)

    case step do
      :left -> {go_split(left, steps), right}
      :right -> {left, go_split(right, steps)}
    end
  end

  defp explode2(numbers, []) do
    {0, numbers}
  end

  defp explode2({left, right} = numbers, path) do
    {[step], path} = Enum.split(path, 1)

    case step do
      :left ->
        {left, {lc, rc}} = explode2(left, path)

        carried_right = add_carry_to_right(right, rc)

        rc = if right == carried_right do
          rc
        else
          0
        end

        {{left, carried_right}, {lc, rc}}
      :right ->
        {right, {lc, rc}} = explode2(right, path)

        carried_left = add_carry_to_left(left, lc)

        lc = if left == carried_left do
          lc
        else
          0
        end

        {{carried_left, right}, {lc, rc}}
    end
  end

  defp explode({left, right} = numbers, depth \\ 1) do
    if depth == 4 do
      cond do
        # {1, 1}
        is_number(left) && is_number(right) -> {{left, right}, {0, 0}}

        # {1, {1, 1}
        is_number(left) ->
          {rl, rr} = right
          {{split(left + rl), 0}, {0, rr}}

        # {{1, 1}, 1}
        is_number(right) ->
          {ll, lr} = left
          {{0, split(right + lr)}, {ll, 0}}
      end
    else
      {left, {llc, rc}} = if is_number(left) do
        {left, {0, 0}}
      else
        explode(left, depth + 1)
      end

      right = add_carry_to_right(right, rc)

      {right, {lc, rrc}} = if is_number(right) do
        {right, {0, 0}}
      else
        explode(right, depth + 1)
      end

      left = add_carry_to_left(left, lc)

      {{left, right}, {lc + llc, rc + rrc}}
    end
  end

  defp add_carry_to_left(left, carry) do
    if is_number(left) do
      left + carry
    else
      {ll, lr} = left
      {ll, add_carry_to_left(lr, carry)}
    end
  end

  defp add_carry_to_right(right, carry) do
    if is_number(right) do
      right + carry
    else
      {rl, rr} = right
      {add_carry_to_right(rl, carry), rr}
    end
  end

  defp split({left, right}) do
    {split(left), split{right}}
  end

  defp split(number) do
    if number >= 10 do
      {floor(number / 2), ceil(number / 2)}
    else
      number
    end
  end

  defp addition(left, right) do
    IO.write("  ")
    IO.inspect(right)
    IO.write("+ ")
    IO.inspect(left)
    result = reduce({right, left})

    IO.write("= ")
    IO.inspect(result)
    IO.puts("")
    result
  end

  defp magnitude({left, right}) do
    magnitude(left) * 3 + magnitude(right) * 2
  end

  defp magnitude(n), do: n

  defp test() do
    [
      {reduce({{{{{9, 8}, 1}, 2}, 3}, 4}), {{{{0, 9}, 2}, 3}, 4}},
      {reduce({7, {6, {5, {4, {3, 2}}}}}), {7, {6, {5, {7, 0}}}}},
      {reduce({{6, {5, {4, {3, 2}}}}, 1}), {{6, {5, {7, 0}}}, 3}},
      {reduce_step({{3, {2, {1, {7, 3}}}}, {6, {5, {4, {3, 2}}}}}), {{3, {2, {8, 0}}}, {9, {5, {4, {3, 2}}}}}},
      {reduce({{3, {2, {8, 0}}}, {9, {5, {4, {3, 2}}}}}), {{3, {2, {8, 0}}}, {9, {5, {7, 0}}}}},
      {reduce(10), {5, 5}},
      {reduce(11), {5, 6}},
      {reduce(12), {6, 6}},
      #{addition({{{{4, 3}, 4}, 4}, {7, {{8, 4}, 9}}}, {1, 1}), {{{{0, 7}, 4}, {{7, 8}, {6, 0}}}, {8, 1}}},
      {magnitude({9,1}), 29},
      {magnitude({1,9}), 21},
      {magnitude({{9,1},{1,9}}), 129},
    ]
    |> Enum.each(
         fn {left, right} = c ->
           if left != right do
             IO.inspect({:test_failed, c})
           end
         end
       )
  end
end
