defmodule Day24P2 do

  import File, only: [read!: 1]
  import Enum, only: [chunk_every: 2, reduce: 3, at: 2]
  import String, only: [to_integer: 1]

  def solve(filename) do
    read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> chunk_every(18)
    |> run()
  end

  defp run(instructions, z \\ 0, num \\ 0)
  defp run([], _, num), do: num

  defp run([ins | instructions], z, num) do
    reduce(
      1..9,
      nil,
      fn i, found ->
        if found do
          found
        else
          result = run_chunk(i, z, ins)

          if result do
            run(instructions, result, num * 10 + i)
          end
        end
      end
    )
  end

  defp run_chunk(input, z, instructions) do
    x_offset = get_instruction_value(instructions, 5)
    y_offset = get_instruction_value(instructions, 15)

    if x_offset > 0 do
      z * 26 + input + y_offset
    else
      x = rem(z, 26) + x_offset

      if x == input, do: floor(z / 26)
    end
  end

  defp get_instruction_value(ins, ins_offset, value_offset \\ 2) do
    ins
    |> at(ins_offset)
    |> String.split(" ")
    |> at(value_offset)
    |> to_integer()
  end
end
