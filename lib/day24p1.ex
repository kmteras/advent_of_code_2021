defmodule Day24P1 do
  def solve(filename) do
    instructions =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")

    run(instructions)
  end

  defp checksum(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14) do
    s1 = n1 + 8
    s2 = s1 * 26 + n2 + 13
    s3 = s2 * 26 + n3 + n4 + 9
    s4 = s3 * 26 + n5 + 11
    s5 = s4 * 26 * n6 + 4
    s6 = s5 * 26 + n7 + n8 + n9 + 36

    s6 * 26 + n10 + n11 + n12 + n13 + n14 + 37
  end

  defp run(instructions) do
    93333333999999..11111111111111
    |> Enum.reduce(
         nil,
         fn n, biggest ->
           input =
             92793949489995
             |> Integer.to_string()
             |> String.graphemes()
             |> Enum.reverse()

           if Enum.member?(input, "0") do
             0
           else
             {state, _} = run(instructions, input)

             valid_num = Map.get(state, "z")

             str_input = Enum.join(input)

             if valid_num == 0 do
               IO.inspect({str_input, Map.get(state, "z")})
             else
               IO.inspect({str_input, state})
             end
           end
         end
       )
  end

  defp run(instructions, input) do
    state = %{
      "w" => 0,
      "x" => 0,
      "y" => 0,
      "z" => 0
    }

    Enum.reduce(
      instructions,
      {state, input},
      fn line, {state, input} ->
        ins = String.split(line, " ")

        case ins do
          ["inp", r] ->
            {[v], input} = Enum.split(input, 1)
            v = String.to_integer(v)
            state = Map.put(state, r, -v)
            {state, input}
          ["add", l, r] ->
            lv = Map.get(state, l)
            rv = get_right_value(state, r)
            state = Map.put(state, l, lv + rv)
            {state, input}
          ["mod", l, r] ->
            lv = Map.get(state, l)
            rv = get_right_value(state, r)
            state = Map.put(state, l, rem(lv, rv))
            {state, input}
          ["div", l, r] ->
            lv = Map.get(state, l)
            rv = get_right_value(state, r)
            state = Map.put(state, l, floor(lv / rv))
            {state, input}
          ["mul", l, r] ->
            lv = Map.get(state, l)
            rv = get_right_value(state, r)
            state = Map.put(state, l, lv * rv)
            {state, input}
          ["eql", l, r] ->
            lv = Map.get(state, l)
            rv = get_right_value(state, r)
            v = if lv == rv, do: 1, else: 0
            state = Map.put(state, l, v)
            {state, input}
        end
      end
    )
  end

  def get_right_value(state, r) do
    case Integer.parse(r) do
      {integer, _} ->
        integer
      :error ->
        Map.get(state, r)
    end
  end
end
