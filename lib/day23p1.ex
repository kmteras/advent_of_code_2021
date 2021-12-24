defmodule Day23P1 do

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
      [String.at(Enum.at(lines, 2), 3), String.at(Enum.at(lines, 3), 3)],
      [String.at(Enum.at(lines, 2), 5), String.at(Enum.at(lines, 3), 5)],
      [String.at(Enum.at(lines, 2), 7), String.at(Enum.at(lines, 3), 7)],
      [String.at(Enum.at(lines, 2), 9), String.at(Enum.at(lines, 3), 9)]
    ]

    step(hallway, pods)
  end

  defp step(hallway, pods, cost \\ 0) do
    IO.inspect({hallway, pods, cost})
    if is_solved(hallway, pods) do
      cost
    else
      0..3
      |> Enum.reduce(10000000, fn i, sum -> min(sum, move_from_pod(hallway, pods, cost, i, sum)) end)
    end
  end

  defp move_from_pod(hallway, pods, cost, i, sum) do
    {{value, step}, pods} = get_from_pod(pods, i)

    if value == nil do
      sum
    else
      # TODO: Optimize away the places where it cannot go
      # TODO: Also no movement
      [0, 1, 3, 5, 7, 9, 10]
      |> Enum.reduce(
           10000000,
           fn h, sum -> min(sum, move_into_hallway(hallway, pods, cost, i, h, sum, value, step)) end
         )
      sum
    end
  end

  defp move_into_hallway(hallway, pods, cost, i, h, sum, value, step) do
    # TODO Check if there is anything in the
    if Enum.at(hallway, h) != nil do
      sum
    else
      hallway = replace_at(hallway, h, value)
      cost = get_cost(value, step, i, h)

      # TODO: No movement into pod
      [0, 1, 3, 5, 7, 9, 10]
      |> Enum.reduce(10000000, fn hp, sum -> min(sum, move_into_pod(hallway, pods, cost, i, h, hp)) end)

      step(hallway, pods, cost)
    end
  end

  defp move_into_pod(hallway, pods, cost, i, h, hp) do
    if Enum.at(hallway, hp) == nil do
      step(hallway, pods, cost)
    else
      amphi = Enum.at(hallway, hp)
      amphi_pod = Map.get(@right_pods, amphi)

      case Enum.at(pods, amphi_pod) do
        [nil, nil] ->
          hallway = replace_at(hallway, hp, nil)
          pods = replace_at(pods, amphi_pod, [nil, amphi])
          cost = cost
          step(hallway, pods, cost)

        [nil, amphi] ->
          hallway = replace_at(hallway, hp, nil)
          pods = replace_at(pods, amphi_pod, [amphi, amphi])
          cost = cost
          step(hallway, pods, cost)

        _ ->
          100000000000
          #step(hallway, pods, cost)
      end
    end
  end

  defp is_solved(hallway, pods) do
    if !Enum.all?(hallway, fn h -> h == nil end) do
      false
    else
      pods == [["A", "A"], ["B", "B"], ["C", "C"], ["D", "D"]]
    end
  end

  defp get_cost(amphipod, steps, pod_index, hallway_index) do
    Map.get(@cost, amphipod) * (steps + abs(hallway_index - (pod_index * 2 + 2)))
  end

  defp get_from_pod(pods, pod_index) do
    pod = Enum.at(pods, pod_index)

    if Enum.at(pod, 0) == nil do
      if Enum.at(pod, 1) == nil do
        {{nil, 0}, pods}
      else
        value = Enum.at(pod, 1)

        if pod_index == Map.get(@right_pods, value) do
          {{nil, 0}, pods}
        else
          pods = replace_at(pods, pod_index, [nil, nil])

          {{value, 2}, pods}
        end
      end
    else
      value = Enum.at(pod, 0)
      pods = replace_at(pods, pod_index, [nil, Enum.at(pod, 1)])
      {{value, 1}, pods}
    end
  end

  defp replace_at(enum, i, v) do
    enum
    |> Enum.with_index()
    |> Enum.map(
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
