defmodule RucksackThingy do
  defp get_priority(ch_str) do
    [char] = ch_str |> String.to_charlist()

    cond do
      char >= ?a && char <= ?z ->
        char - ?a + 1

      char >= ?A && char <= ?Z ->
        char - ?A + 27

      true ->
        0
    end
  end

  def scan_line(line, acc) do
    line = String.trim(line)
    items_per_side = line |> String.length() |> Integer.floor_div(2)
    {compartment_a, compartment_b} = line |> String.split_at(items_per_side)
    [_, shared] = Regex.run(~r"([#{compartment_a}])", compartment_b)
    acc + get_priority(shared)
  end

  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce(0, &scan_line/2)
  end
end

RucksackThingy.scan("input.txt") |> IO.puts()
