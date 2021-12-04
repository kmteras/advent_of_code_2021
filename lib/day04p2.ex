defmodule Day04P2 do

  def solve(filename) do
    splits =
      File.read!(filename)
      |> String.split("\n\n")

    {[numbers_str], bingo} =
      splits
      |> Enum.split(1)

    numbers =
      numbers_str
      |> String.split(",")

    bingo =
      bingo
      |> Enum.map(
           fn b ->
             b
             |> String.split()
           end
         )

    solve_bingo([], numbers, bingo)
  end

  defp solve_bingo(_, [], _) do
    :wtf
  end

  defp solve_bingo(chosen_numbers, numbers, bingo) do
    {current_number, numbers} =
      numbers
      |> Enum.split(1)

    chosen_numbers = chosen_numbers ++ current_number

    not_winners =
      bingo
      |> Enum.filter(fn b -> !has_won?(chosen_numbers, b) end)

    if length(not_winners) == 0 do
      get_magic_number(
        chosen_numbers,
        bingo
        |> Enum.at(0)
      ) * String.to_integer(current_number |> Enum.at(0))
    else
      solve_bingo(chosen_numbers, numbers, not_winners)
    end
  end

  defp has_won?(numbers, bingo) do
    [
      r00,
      r01,
      r02,
      r03,
      r04,
      r10,
      r11,
      r12,
      r13,
      r14,
      r20,
      r21,
      r22,
      r23,
      r24,
      r30,
      r31,
      r32,
      r33,
      r34,
      r40,
      r41,
      r42,
      r43,
      r44
    ] = bingo

    has_all?([r00, r01, r02, r03, r04], numbers)
    || has_all?([r10, r11, r12, r13, r14], numbers)
    || has_all?([r20, r21, r22, r23, r24], numbers)
    || has_all?([r30, r31, r32, r33, r34], numbers)
    || has_all?([r40, r41, r42, r43, r44], numbers)
    || has_all?([r00, r10, r20, r30, r40], numbers)
    || has_all?([r01, r11, r21, r31, r41], numbers)
    || has_all?([r02, r12, r22, r32, r42], numbers)
    || has_all?([r03, r13, r23, r33, r43], numbers)
    || has_all?([r04, r14, r24, r34, r44], numbers)
    #|| has_all?([r00, r11, r22, r33, r44], numbers)
    #|| has_all?([r04, r13, r22, r31, r40], numbers)
  end

  defp has_all?(row_numbers, numbers) do
    row_numbers
    |> Enum.reduce(true, fn number, isin -> isin && Enum.member?(numbers, number) end)
  end

  defp get_magic_number(chosen_numbers, bingo) do
    bingo
    |> Enum.filter(fn number -> !Enum.member?(chosen_numbers, number) end)
    |> Enum.reduce(0, fn number, sum -> sum + String.to_integer(number) end)
  end
end
