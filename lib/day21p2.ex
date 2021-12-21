defmodule Day21P2 do

  def solve(filename) do
    [pos1, pos2] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")

    [_, p1] = String.split(pos1, ": ")
    [_, p2] = String.split(pos2, ": ")

    p1 = String.to_integer(p1)
    p2 = String.to_integer(p2)

    :ets.new(:func, [:named_table])

    turn({p1, 0, p2, 0, 1})
  end

  def turn({p1, p1s, p2, p2s, player} = params) do
    #IO.inspect({{p1s, p2s}, player})
    case :ets.lookup(:func, params) do
      [{_, a}] ->
        #IO.inspect({params, a})
        a
      [] ->
        ans = Enum.reduce(
          1..3,
          {0, 0},
          fn n1, {s1, s2} ->
            {a1, a2} = Enum.reduce(
              1..3,
              {0, 0},
              fn n2, {s1, s2} ->
                {a1, a2} = Enum.reduce(
                  1..3,
                  {0, 0},
                  fn n3, {s1, s2} ->
                    n = n1 + n2 + n3
                    {_, p1s, _, p2s, _} = params = if player == 1 do
                      p = move(p1, n)
                      {p, p1s + p, p2, p2s, 2}
                    else
                      p = move(p2, n)
                      {p1, p1s, p, p2s + p, 1}
                    end

                    cond do
                      p1s >= 21 ->
                        {s1 + 1, s2 + 0}
                      p2s >= 21 ->
                        {s1 + 0, s2 + 1}
                      true ->
                        {p1w, p2w} = turn(params)
                        {s1 + p1w, s2 + p2w}
                    end
                  end
                )
                {s1 + a1, s2 + a2}
              end
            )
            {s1 + a1, s2 + a2}
          end
        )
        :ets.insert(:func, {params, ans})
        ans
    end
  end

  def move(pos, amount) do
    rem(pos - 1 + amount, 10) + 1
  end
end
