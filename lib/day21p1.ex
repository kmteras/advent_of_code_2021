defmodule Day21P1 do

  def solve(filename) do
    [pos1, pos2] =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")

    [_, p1] = String.split(pos1, ": ")
    [_, p2] = String.split(pos2, ": ")

    p1 = String.to_integer(p1)
    p2 = String.to_integer(p2)

    {l, r} = turn({p1, 0, p2, 0})
    l * r
  end

  def turn({p1, p1s, p2, p2s}, player \\ 1, count \\ 0, die \\ 1) do
    IO.inspect({{p1, p1s, p2, p2s}, player, count, die})
    cond do
      p1s >= 1000 ->
        {p2s, count}
      p2s >= 1000 ->
        {p1s, count}

      true ->
        {n1, die} = die(die)
        {n2, die} = die(die)
        {n3, die} = die(die)

        {p1, p1s, p2, p2s, player} = if player == 1 do

          p = move(p1, n1 + n2 + n3)

          {p, p1s + p, p2, p2s, 2}
        else

          p = move(p2, n1 + n2 + n3)

          {p1, p1s, p, p2s + p, 1}
        end

        count = count + 3
        turn({p1, p1s, p2, p2s}, player, count, die)
    end
  end

  def die(n) do
    if n == 100 do
      {n, 1}
    else
      {n, n + 1}
    end
  end

  def move(pos, amount) do
    rem(pos - 1 + amount, 10) + 1
  end
end
