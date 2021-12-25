defmodule Day25P1 do

  import File, only: [read!: 1]
  import Enum, only: [chunk_every: 2, split: 2, reduce: 3, at: 2, map: 2, with_index: 1, filter: 2]
  import String, only: [to_integer: 1, graphemes: 1]
  import Map, only: [get: 2, get: 3, put: 3, merge: 2, has_key?: 2]

  def solve(filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> with_index()
    |> reduce(
         %{},
         fn {line, y}, map ->
           line
           |> graphemes()
           |> with_index()
           |> reduce(
                %{},
                fn {cuc, x}, map -> put(map, {x, y}, cuc) end
              )
           |> merge(map)
         end
       )
    |> move()
  end

  defp move(orig_cucs, depth \\ 1) do
    right_moved =
      Enum.filter(orig_cucs, fn {{x, y}, dir} -> dir == ">" end)
      |> Map.new()
      |> Enum.reduce(
           orig_cucs,
           fn {{x, y}, dir}, cucs ->
             if has_key?(orig_cucs, {x + 1, y}) do
               if get(orig_cucs, {x + 1, y}) == "." do

                 cucs
                 |> put({x, y}, ".")
                 |> put({x + 1, y}, dir)
               else
                 cucs
               end
             else
               if get(orig_cucs, {0, y}) == "." do
                 cucs
                 |> put({x, y}, ".")
                 |> put({0, y}, dir)
               else
                 cucs
               end
             end
           end
         )

    down_moved =
      Enum.filter(right_moved, fn {{x, y}, dir} -> dir == "v" end)
      |> Map.new()
      |> Enum.reduce(
           right_moved,
           fn {{x, y}, dir}, cucs ->
             if has_key?(right_moved, {x, y + 1}) do
               if get(right_moved, {x, y + 1}) == "." do

                 cucs
                 |> put({x, y}, ".")
                 |> put({x, y + 1}, dir)
               else
                 cucs
               end
             else
               if get(right_moved, {x, 0}) == "." do
                 cucs
                 |> put({x, y}, ".")
                 |> put({x, 0}, dir)
               else
                 cucs
               end
             end
           end
         )

    if orig_cucs == down_moved do
      coords_to_string(down_moved)
      |> IO.puts
      depth
    else
      move(down_moved, depth + 1)
    end
  end

  def coords_to_string(letter_coords) do
    max_x = Enum.max(map(letter_coords, &(elem(elem(&1, 0), 0))))
    max_y = Enum.max(map(letter_coords, &(elem(elem(&1, 0), 1))))

    map(
      0..max_y,
      fn y ->
        map(
          0..max_x,
          fn x ->
            get(letter_coords, {x, y})
          end
        )
        |> Enum.join("")
      end
    )
    |> Enum.join("\n")
  end
end
