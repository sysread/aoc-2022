#!/usr/bin/env elixir

defmodule MaTreeX do
  defstruct rows: [], cols: [], row_size: 0, col_size: 0

  @type t :: %__MODULE__{
          rows: list(list(String.t())),
          cols: list(list(String.t())),
          row_size: non_neg_integer,
          col_size: non_neg_integer
        }

  def new(input_file) do
    rows = input_file |> scan
    cols = List.zip(rows) |> Enum.map(&Tuple.to_list/1)
    %__MODULE__{rows: rows, cols: cols, row_size: length(rows), col_size: length(cols)}
  end

  def scan(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce([], &scan_line/2)
    |> Enum.reverse()
  end

  def scan_line(line, acc) do
    trees =
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(fn s ->
        {i, _} = Integer.parse(s)
        i
      end)

    [trees | acc]
  end

  def find_visible(self) do
    find_visible(self, [], 0, 0)
  end

  def find_visible(self, acc, x, y) do
    cond do
      y >= self.col_size ->
        acc |> Enum.count()

      x >= self.row_size ->
        find_visible(self, acc, 0, y + 1)

      is_hidden?(self, x, y) ->
        find_visible(self, acc, x + 1, y)

      true ->
        find_visible(self, [{x, y} | acc], x + 1, y)
    end
  end

  def get_height(self, x, y) do
    self.rows |> Enum.at(y) |> Enum.at(x)
  end

  def is_hidden?(_, x, _) when x == 0, do: false
  def is_hidden?(_, _, y) when y == 0, do: false
  def is_hidden?(self, x, _) when x == self.row_size - 1, do: false
  def is_hidden?(self, _, y) when y == self.col_size - 1, do: false

  def is_hidden?(self, x, y) do
    height = get_height(self, x, y)

    before_in_row = self.rows |> Enum.at(y) |> Enum.slice(0, x)
    after_in_row = self.rows |> Enum.at(y) |> Enum.slice(x + 1, self.row_size - x - 1)

    before_in_col = self.cols |> Enum.at(x) |> Enum.slice(0, y)
    after_in_col = self.cols |> Enum.at(x) |> Enum.slice(y + 1, self.col_size - y - 1)

    before_in_row |> Enum.any?(fn tree -> tree >= height end) &&
      after_in_row |> Enum.any?(fn tree -> tree >= height end) &&
      before_in_col |> Enum.any?(fn tree -> tree >= height end) &&
      after_in_col |> Enum.any?(fn tree -> tree >= height end)
  end
end

MaTreeX.new("input.txt")
|> MaTreeX.find_visible()
|> IO.puts()
