defmodule RucksackThingy do
  defp get_priority(char) do
    cond do
      char >= ?a && char <= ?z ->
        char - ?a + 1

      char >= ?A && char <= ?Z ->
        char - ?A + 27

      true ->
        0
    end
  end

  def scan_line([a, b, c], acc) do
    shared =
      MapSet.new(a |> String.to_charlist())
      |> MapSet.intersection(MapSet.new(b |> String.to_charlist()))
      |> MapSet.intersection(MapSet.new(c |> String.to_charlist()))

    [char] = shared |> MapSet.to_list()

    acc + get_priority(char)
  end

  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, &scan_line/2)
  end
end

RucksackThingy.scan("input.txt") |> IO.puts()
