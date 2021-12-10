defmodule Day10P2 do

  def solve(filename) do
    points = %{"(" => 1, "[" => 2, "{" => 3, "<" => 4}

    sorted =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&is_corrupt/1)
      |> Enum.filter(fn {result, _} -> result == :incomplete end)
      |> Enum.map(
           fn {_, list} ->
             list
             |> Enum.reduce(0, fn char, sum -> sum * 5 + Map.get(points, char) end)
           end
         )
      |> Enum.sort()

    Enum.at(sorted, div(length(sorted), 2))
  end

  def is_corrupt(line) do
    result =
      line
      |> Enum.reduce(
           [],
           fn c, queue ->
             case queue do
               {:corrupt, char} -> {:corrupt, char}
               {:incomplete, char} -> {:incomplete, char}
               queue ->
                 case c do
                   "(" -> [c] ++ queue
                   "[" -> [c] ++ queue
                   "{" -> [c] ++ queue
                   "<" -> [c] ++ queue

                   ")" ->
                     if Enum.at(queue, 0) == "(" do
                       Enum.drop(queue, 1)
                     else
                       if Enum.member?(["[", "{", "<"], Enum.at(queue, 0)) do
                         {:corrupt, c}
                       else
                         {:incomplete, c}
                       end
                     end
                   "]" ->
                     if Enum.at(queue, 0) == "[" do
                       Enum.drop(queue, 1)
                     else
                       if Enum.member?(["(", "{", "<"], Enum.at(queue, 0)) do
                         {:corrupt, c}
                       else
                         {:incomplete, c}
                       end
                     end
                   "}" ->
                     if Enum.at(queue, 0) == "{" do
                       Enum.drop(queue, 1)
                     else
                       if Enum.member?(["(", "[", "<"], Enum.at(queue, 0)) do
                         {:corrupt, c}
                       else
                         {:incomplete, c}
                       end
                     end
                   ">" ->
                     if Enum.at(queue, 0) == "<" do
                       Enum.drop(queue, 1)
                     else
                       if Enum.member?(["(", "{", "["], Enum.at(queue, 0)) do
                         {:corrupt, c}
                       else
                         {:incomplete, c}
                       end
                     end
                 end
             end
           end
         )
    case result do
      {type, info} -> {type, info}
      list -> {:incomplete, list}
    end
  end
end
