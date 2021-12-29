defmodule Day23P1 do

  import File, only: [read!: 1]
  import Enum, only: [chunk_every: 2, split: 2, reduce: 3, at: 2, map: 2, with_index: 1, filter: 2]
  import String, only: [to_integer: 1]
  import Map, only: [get: 2, get: 3, put: 3]

  @cost %{
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000
  }

  @right_pods %{
    "A" => 0,
    "B" => 1,
    "C" => 2,
    "D" => 3
  }

  def solve(filename) do
    lines =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")

    hallway = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    pods = [
      [String.at(at(lines, 2), 3), String.at(at(lines, 3), 3)],
      [String.at(at(lines, 2), 5), String.at(at(lines, 3), 5)],
      [String.at(at(lines, 2), 7), String.at(at(lines, 3), 7)],
      [String.at(at(lines, 2), 9), String.at(at(lines, 3), 9)]
    ]

    step(hallway, pods)
  end

  defp step(hallway, pods, cost \\ 0) do
    IO.inspect({hallway, pods, cost})
    if is_solved(pods) do
      cost
    else
      unsolved_pods_indexes = get_movable_pods_indexes(pods)

      pods_to_move = unsolved_pods_indexes ++ [nil]

      reduce(pods_to_move, nil, fn i, sum -> min(sum, move_from_pod(hallway, pods, cost, i, sum)) end)
    end
  end

  defp move_from_pod(hallway, pods, cost, i, sum) do
    # No movement into hallway
    if i == nil do
      [0, 1, 3, 5, 7, 9, 10]
      |> reduce(nil, fn from_h, sum -> min(sum, move_into_pod(hallway, pods, cost, from_h)) end)
    else
      {{value, step}, pods} = get_from_pod(pods, i)

      if value == nil do
        sum
      else
        # TODO: Optimize away the places where it cannot go
        # TODO: Also no movement
        [0, 1, 3, 5, 7, 9, 10]
        |> reduce(
             nil,
             fn h, sum -> min(sum, move_into_hallway(hallway, pods, cost, i, h, sum, value, step)) end
           )
        sum
      end
    end
  end

  defp move_into_hallway(hallway, pods, cost, i, h, sum, value, step) do
    # TODO Check if there is anything in the
    if at(hallway, h) != nil do
      sum
    else
      hallway = replace_at(hallway, h, value)
      cost = get_cost(value, step, i, h)

      # TODO: No movement into pod
      [0, 1, 3, 5, 7, 9, 10]
      |> reduce(nil, fn from_h, sum -> min(sum, move_into_pod(hallway, pods, cost, from_h)) end)

      #step(hallway, pods, cost)
    end
  end

  defp move_into_pod(hallway, pods, cost, from_h) do
    if at(hallway, from_h) == nil do
      step(hallway, pods, cost)
    else
      amphi = at(hallway, from_h)
      amphi_pod = get(@right_pods, amphi)

      # TODO: Check nothing is in the way

      case at(pods, amphi_pod) do
        [nil, nil] ->
          hallway = replace_at(hallway, from_h, nil)
          pods = replace_at(pods, amphi_pod, [nil, amphi])
          cost = cost # TODO
          step(hallway, pods, cost)

        [nil, ^amphi] ->
          hallway = replace_at(hallway, from_h, nil)
          pods = replace_at(pods, amphi_pod, [amphi, amphi])
          cost = cost # TODO
          step(hallway, pods, cost)

        _ ->
          nil
      end
    end
  end

  defp is_solved(pods) do
    get_unsolved_pods_indexes(pods) == []
  end

  @index_to_pod %{
    0 => "A",
    1 => "B",
    2 => "C",
    3 => "D"
  }

  defp get_movable_pods_indexes(pods) do
    pods
    |> with_index()
    |> filter(fn {pod, index} ->
      right_amphi = get(@index_to_pod, index)
      pod != [right_amphi, right_amphi] || pod != [nil, right_amphi] || pod != [nil, nil]
    end)
    |> map(fn {pod, index} -> index end)
  end

  defp get_unsolved_pods_indexes(pods) do
    pods
    |> with_index()
    |> filter(fn {pod, index} ->
      right_amphi = get(@index_to_pod, index)
      pod != [right_amphi, right_amphi]
    end)
    |> map(fn {pod, index} -> index end)
  end

  defp get_cost(amphipod, steps, pod_index, hallway_index) do
    get(@cost, amphipod) * (steps + abs(hallway_index - (pod_index * 2 + 2)))
  end

  defp get_from_pod(pods, pod_index) do
    pod = at(pods, pod_index)

    if at(pod, 0) == nil do
      if at(pod, 1) == nil do
        {{nil, 0}, pods}
      else
        value = at(pod, 1)

        if pod_index == get(@right_pods, value) do
          {{nil, 0}, pods}
        else
          pods = replace_at(pods, pod_index, [nil, nil])

          {{value, 2}, pods}
        end
      end
    else
      value = at(pod, 0)
      pods = replace_at(pods, pod_index, [nil, at(pod, 1)])
      {{value, 1}, pods}
    end
  end

  defp replace_at(enum, i, v) do
    enum
    |> with_index()
    |> map(
         fn {value, index} ->
           if index == i do
             v
           else
             value
           end
         end
       )
  end
end
