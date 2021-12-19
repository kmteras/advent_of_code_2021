defmodule Day19P1 do

  # [0, 0, 0]
  # [68, -1246, -43]
  # [1105, -1205, 1229]
  # [-92, -2380, -20]
  # [-20, -1133, 1061]

  def solve(filename) do
    scanners
    = File.read!(filename)
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(
           &String.split(&1, "\n")
            |> Enum.drop(1)
            |> Enum.map(
                 fn line ->
                   String.split(line, ",")
                   |> Enum.map(fn p -> String.to_integer(p) end)
                 end
               )
         )

    d =
      beacons(scanners, MapSet.new(Enum.at(scanners, 0)))
      |> Map.new()
      |> IO.inspect(charlists: :as_lists)

    scanners
    |> Enum.with_index()
    |> Enum.reduce(
         MapSet.new([]),
         fn {scanner, i}, s ->
           {perms, offset} = Map.get(d, i, {[], [0, 0, 0]})
           scanner
           |> Enum.map(&(vector_add(perm(&1, perms), offset)))
           |> MapSet.new()
           |> MapSet.union(s)
         end
       )
    |> MapSet.size()
  end

  def beacons(scanners, beacons, discovered \\ [{0, {[], [0, 0, 0]}}]) do
    if Enum.count(discovered) >= Enum.count(scanners) do
      discovered
    else
      d = discovered
          |> Enum.reduce(
               discovered,
               fn {i, {perms, o}}, r ->
                 d =
                   0..(Enum.count(scanners) - 1)
                   |> Enum.reduce(
                        [],
                        fn j, r ->
                          if Enum.any?(discovered, fn {n, {_, _}} -> n == j end) do
                            r
                          else
                            case offset(scanners, i, j, perms) do
                              nil -> r
                              {permutation, offset} ->
                                [{j, {[permutation] ++ perms, vector_add(o, offset)}}] ++ r
                            end
                          end
                        end
                      )
                 d ++ r
               end
             )
          |> Map.new()
          |> Map.to_list()

      beacons(scanners, beacons, d)
    end
  end

  def with_coords(current_set, scanners, j, offset, perms) do
    second_scanner = Enum.at(scanners, j)

    second_scanner_offset =
      second_scanner
      |> Enum.map(&vector_add(perm(&1, perms), offset))
      |> MapSet.new()

    MapSet.union(current_set, second_scanner_offset)
  end

  def offset(scanners, i, j, perms \\ []) do
    first_scanner = Enum.at(scanners, i)
    second_scanner = Enum.at(scanners, j)

    first_lengths = lines(first_scanner)
    second_lengths = lines(second_scanner)

    common =
      MapSet.intersection(
        Map.keys(first_lengths)
        |> MapSet.new(),
        Map.keys(second_lengths)
        |> MapSet.new()
      )

    if MapSet.size(common) == 0 do
      nil
    else
      first_group =
        Map.take(first_lengths, MapSet.to_list(common))
        |> Map.values()
        |> Enum.reduce(
             MapSet.new(),
             fn {l, r}, set ->
               MapSet.put(set, l)
               |> MapSet.put(r)
             end
           )

      second_group =
        Map.take(second_lengths, MapSet.to_list(common))
        |> Map.values()
        |> Enum.reduce(
             MapSet.new(),
             fn {l, r}, set ->
               MapSet.put(set, l)
               |> MapSet.put(r)
             end
           )

      first_group = Enum.map(MapSet.to_list(first_group), &perm(&1, perms))
      second_group = Enum.map(MapSet.to_list(second_group), &perm(&1, perms))

      find_offset(first_group, second_group)
    end
  end

  def lines(coords) do
    Enum.reduce(
      coords,
      %{},
      fn c1, s ->
        Enum.reduce(
          coords,
          %{},
          fn c2, s ->
            if c1 == c2 do
              s
            else
              Map.put(s, distance(c1, c2), {c1, c2})
            end
          end
        )
        |> Map.merge(s)
      end
    )
  end

  def find_groups(length_coords_map) do
    coords = Map.values(length_coords_map)

    coords
    |> Enum.reduce(
         [],
         fn {left, right}, list_of_sets ->
           lc = find_contains(list_of_sets, left)
           rc = find_contains(list_of_sets, right)
           list_of_sets =
             case lc do
               {true, pos} ->
                 # Put right into set
                 List.update_at(list_of_sets, pos, &(MapSet.put(&1, right)))
               {false, _} ->
                 case rc do
                   {true, pos} ->
                     # Put left into set
                     List.update_at(list_of_sets, pos, &(MapSet.put(&1, left)))
                   {false, _} ->
                     # Put both into new set
                     [MapSet.new([left, right])] ++ list_of_sets
                 end
             end
         end
       )
    |> Enum.filter(fn set -> MapSet.size(set) >= 12 end)
  end

  def find_contains(list_of_sets, coordinate) do
    list_of_sets
    |> Enum.with_index()
    |> Enum.reduce(
         {false, nil},
         fn {set, index}, {found, _} = best ->
           if found == true do
             best
           else
             if MapSet.member?(set, coordinate) do
               {true, index}
             else
               {false, nil}
             end
           end
         end
       )
  end

  def find_offset(first_coords, second_coords) do
    m =
      0..47
      |> Enum.map(
           fn i ->
             {i, Enum.map(second_coords, fn coords -> perm(coords, i) end)}
           end
         )
      |> Enum.map(&find_offset2(first_coords, elem(&1, 1), elem(&1, 0)))
      |> Enum.filter(&(&1 != nil))

    case m do
      [match] -> match
      [] -> nil
      m -> nil
    end
  end

  def find_offset2(first_coords, second_coords, perm) do
    a1 = average_of_coords(first_coords)
    a2 = average_of_coords(second_coords)

    a = vector_div(vector_sub(a1, a2), Enum.count(first_coords))

    if is_every_coord(first_coords, second_coords, a) do
      {perm, a}
    else
      nil
    end
  end

  def is_every_coord(coords1, coords2, a), do: Enum.all?(coords1, &is_some_coord(vector_sub(&1, a), coords2))

  def is_some_coord(coord, coords) do
    Enum.member?(coords, coord)
  end

  def average_of_coords(coords) do
    Enum.reduce(coords, &vector_add/2)
  end

  def distances(coords) do
    {[first], coords} = Enum.split(coords, 1)
    Enum.map(coords, fn c -> {distance(c, first), {c, first}} end)
    |> Map.new()
  end


  def distance([x1, y1, z1], [x2, y2, z2]) do
    :math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2)
  end

  def vector_sub({left, right}), do: vector_sub(left, right)
  def vector_sub([x1, y1, z1], [x2, y2, z2]), do: [x1 - x2, y1 - y2, z1 - z2]

  def vector_add([x1, y1, z1], [x2, y2, z2]), do: [x1 + x2, y1 + y2, z1 + z2]

  def vector_prod([x1, y1, z1], [x2, y2, z2]), do: [x1 * x2, y1 * y2, z1 * z2]

  def vector_div([x1, y1, z1], div), do: [floor(x1 / div), floor(y1 / div), floor(z1 / div)]

  def perm(coords, []), do: coords

  def perm(coords, n) when is_list(n) do
    {[p], n} = Enum.split(n, 1)
    perm(perm(coords, n), p)
  end

  def perm([x, y, z], n) do
    p =
      [
        [1, 1, 1],
        [1, -1, 1],
        [1, -1, -1],
        [1, 1, -1],

        [-1, 1, 1],
        [-1, -1, 1],
        [-1, -1, -1],
        [-1, 1, -1],
      ]
      |> Enum.at(rem(n, 8))

    [
      [x, y, z],
      [x, z, y],

      [y, x, z],
      [y, z, x],

      [z, x, y],
      [z, y, x],
    ]
    |> Enum.at(floor(n / 8))
    |> vector_prod(p)
  end
end
