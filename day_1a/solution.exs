defmodule MaxElfCalorieCounter do
  def scan(input_file) do
    {_, max} = File.stream!(input_file) |> Enum.reduce({0, 0}, &scan_line/2)
    max
  end

  defp scan_line("\n", {acc, max}) do
    if acc > max do
      {0, acc}
    else
      {0, max}
    end
  end

  defp scan_line(line, {acc, max}) do
    {num, _rem} = Integer.parse(line)
    {acc + num, max}
  end
end

MaxElfCalorieCounter.scan("input.txt") |> IO.puts()
