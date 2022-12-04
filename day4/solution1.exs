defmodule OverlapFinder do
  def scan_line(line, acc) do
    [a_start, a_end, b_start, b_end] =
      Regex.run(~r{^(\d+)-(\d+),(\d+)-(\d+)}, line)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    a = MapSet.new(a_start..a_end)
    b = MapSet.new(b_start..b_end)

    acc +
      cond do
        MapSet.subset?(a, b) -> 1
        MapSet.subset?(b, a) -> 1
        true -> 0
      end
  end

  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce(0, &scan_line/2)
  end
end

OverlapFinder.scan("input.txt") |> IO.puts()
