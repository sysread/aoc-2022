#!/usr/bin/env elixir

defmodule TerminalLogReader do
  defstruct files: %{}, path: []

  @total_space 70_000_000
  @min_for_update 30_000_000

  def new(files \\ %{"" => 0}, path \\ []) do
    %__MODULE__{
      files: files,
      path: path
    }
  end

  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce(new(), &scan_line/2)
  end

  def scan_line(line, acc) do
    line
    |> String.trim()
    |> String.split()
    |> parse(acc)
  end

  def parse(["$", "cd", "/"], acc), do: new(acc.files, [])
  def parse(["$", "cd", ".."], acc), do: new(acc.files, cdr(acc.path))
  def parse(["$", "cd", node], acc), do: new(acc.files, [node | acc.path])
  def parse(["$", "ls"], acc), do: acc
  def parse(["dir", name], acc), do: new(acc.files |> Map.put(mkpath(acc, name), 0), acc.path)

  def parse([str_size, name], acc) do
    {size, _rem} = Integer.parse(str_size)

    new(
      acc.files |> Map.put(mkpath(acc, name), size),
      acc.path
    )
  end

  defp cdr([_ | cdr]), do: cdr
  defp mkpath(acc, file), do: [file | acc.path] |> Enum.reverse() |> Enum.join("/")

  def list_dir_sizes(acc) do
    acc.files
    |> Map.keys()
    |> Enum.filter(fn d -> acc.files[d] == 0 end)
    |> Enum.map(fn dir ->
      {
        dir,
        acc.files
        |> Map.filter(fn {file, _} -> String.starts_with?(file, dir) end)
        |> Map.values()
        |> Enum.sum()
      }
    end)
    |> Map.new()
  end

  def collect_sizes(acc) do
    sizes = acc |> list_dir_sizes()
    used = sizes[""]
    free = @total_space - used
    need = @min_for_update - free

    sizes
    |> Map.filter(fn {_, size} -> size >= need end)
    |> Map.values()
    |> Enum.min()
  end
end

TerminalLogReader.scan("input.txt")
|> TerminalLogReader.collect_sizes()
|> IO.puts()
