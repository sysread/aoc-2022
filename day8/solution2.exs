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

  def get_best_score(self) do
    get_best_score(self, [], 0, 0)
  end

  def get_best_score(self, acc, x, y) do
    cond do
      y >= self.col_size -> acc |> Enum.max()
      x >= self.row_size -> get_best_score(self, acc, 0, y + 1)
      true -> get_best_score(self, [get_score(self, x, y) | acc], x + 1, y)
    end
  end

  def get_height(self, x, y) do
    self.rows |> Enum.at(y) |> Enum.at(x)
  end

  def get_score(_, x, _) when x == 0, do: 0
  def get_score(_, _, y) when y == 0, do: 0
  def get_score(self, x, _) when x == self.row_size - 1, do: 0
  def get_score(self, _, y) when y == self.col - 1, do: 0

  def get_score(self, x, y) do
    height = get_height(self, x, y)

    before_in_row =
      self.rows |> Enum.at(y) |> Enum.slice(0, x) |> Enum.reverse() |> count_visible(height)

    after_in_row =
      self.rows |> Enum.at(y) |> Enum.slice(x + 1, self.row_size - x - 1) |> count_visible(height)

    before_in_col =
      self.cols |> Enum.at(x) |> Enum.slice(0, y) |> Enum.reverse() |> count_visible(height)

    after_in_col =
      self.cols |> Enum.at(x) |> Enum.slice(y + 1, self.col_size - y - 1) |> count_visible(height)

    before_in_row * after_in_row * before_in_col * after_in_col
  end

  def count_visible(trees, height), do: count_visible(trees, height, 0)
  def count_visible([], _, acc), do: acc
  def count_visible([tree | _], height, acc) when tree >= height, do: acc + 1
  def count_visible([_ | rest], height, acc), do: count_visible(rest, height, acc + 1)
end

MaTreeX.new("input.txt")
|> MaTreeX.get_best_score()
|> IO.puts()
