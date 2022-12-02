defmodule MaxThreeElfCalorieCounter do
  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce([], &scan_line/2)
    |> choose()
    |> Enum.sum()
  end

  defp scan_line("\n", candidates), do: [0] ++ (candidates |> choose())
  defp scan_line(line, [acc | rest]), do: [acc + read_number(line)] ++ rest
  defp scan_line(line, []), do: [read_number(line)]

  defp read_number(line) do
    {num, _rem} = Integer.parse(line)
    num
  end

  defp choose(candidates) do
    candidates
    |> Enum.sort_by(fn x -> x end, :desc)
    |> Enum.slice(0, 3)
  end
end

MaxThreeElfCalorieCounter.scan("input.txt") |> IO.puts()
