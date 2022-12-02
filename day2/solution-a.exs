defmodule RockPaperScissorsScorer do
  @score_rock 1
  @score_paper 2
  @score_scissors 3

  @score_loss 0
  @score_draw 3
  @score_win 6

  @score %{
    # p2: rock
    "A" => %{
      "X" => @score_rock + @score_draw,
      "Y" => @score_paper + @score_win,
      "Z" => @score_scissors + @score_loss
    },
    # p2: paper
    "B" => %{
      "X" => @score_rock + @score_loss,
      "Y" => @score_paper + @score_draw,
      "Z" => @score_scissors + @score_win
    },
    # p2: scissors
    "C" => %{
      "X" => @score_rock + @score_win,
      "Y" => @score_paper + @score_loss,
      "Z" => @score_scissors + @score_draw
    }
  }

  def scan_line(line, acc) do
    [_, p1, p2] = Regex.run(~r{^([ABC]) ([XYZ])}, line)
    acc + @score[p1][p2]
  end

  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce(0, &scan_line/2)
  end
end

RockPaperScissorsScorer.scan("input.txt") |> IO.puts()
