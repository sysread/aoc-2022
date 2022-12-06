#!/usr/bin/env elixir

defmodule StartOfMessageScanner do
  @sop_chars 14

  def scan(input_file) do
    input_file
    |> File.stream!([], 1)
    |> Enum.reduce_while({0, []}, &getch/2)
  end

  def getch(char, {idx, buf}) do
    idx = idx + 1
    buf = [char | buf]

    if is_sop?(buf) do
      {:halt, idx}
    else
      {:cont, {idx, buf}}
    end
  end

  def is_sop?(buf) when length(buf) < @sop_chars, do: false

  def is_sop?(buf),
    do: buf |> Enum.slice(0, @sop_chars) |> MapSet.new() |> MapSet.size() == @sop_chars
end

StartOfMessageScanner.scan("input.txt") |> IO.puts()
