defmodule CrateManager do
  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce(%{}, &scan_line/2)
    |> Map.values()
    |> Enum.map(&List.first/1)
    |> Enum.join("")
  end

  def scan_line(line, acc) do
    line |> parse(acc)
  end

  def parse(line, acc) do
    cond do
      String.contains?(line, "[") -> line |> parse_stack_row(acc, next_key(acc))
      String.starts_with?(line, " 1") -> acc |> build_stacks()
      String.starts_with?(line, "move") -> line |> move(acc)
      true -> acc
    end
  end

  def next_key(acc) do
    1 + (acc |> Map.keys() |> Enum.max(&>=/2, fn -> 0 end))
  end

  def parse_stack_row("\n", acc, key) do
    Map.update(acc, key, [], &Enum.reverse/1)
  end

  def parse_stack_row(line, acc, key) do
    {token, rest} = String.split_at(line, 3)
    rest = String.replace_prefix(rest, " ", "")
    item = String.slice(token, 1, 1)
    acc = Map.update(acc, key, [item], fn stack -> [item | stack] end)
    parse_stack_row(rest, acc, key)
  end

  def build_stacks(acc) do
    rotated =
      acc
      |> Map.values()
      |> List.zip()
      |> Enum.map(fn stack ->
        stack
        |> Tuple.to_list()
        |> Enum.filter(fn s -> s != " " end)
      end)

    keys = 1..(rotated |> Enum.count()) |> Enum.to_list()

    List.zip([keys, rotated]) |> Map.new()
  end

  def move(line, acc) do
    [_, count, from, to] = Regex.run(~r{^move (\d+) from (\d+) to (\d+)}, line)
    {count, _} = Integer.parse(count)
    {from, _} = Integer.parse(from)
    {to, _} = Integer.parse(to)
    move(count, from, to, acc)
  end

  def move(0, _, _, acc) do
    acc
  end

  def move(count, from, to, acc) do
    #IO.puts("MOVE #{count} FROM #{from} TO #{to} IN:")
    #acc |> IO.inspect

    {item, acc} =
      Map.get_and_update(acc, from, fn [car | cdr] ->
        {car, cdr}
      end)

    acc = Map.update(acc, to, [], fn stack -> [item | stack] end)

    move(count - 1, from, to, acc)
  end
end

CrateManager.scan("input.txt") |> IO.puts()
