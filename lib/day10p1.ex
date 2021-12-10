defmodule Day10P1 do

  def solve(filename) do
    points = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&is_corrupt/1)
    |> Enum.filter(fn {result, _} -> result == :corrupt end)
    |> Enum.reduce(0, fn {_, char}, sum -> sum + Map.get(points, char) end)
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
