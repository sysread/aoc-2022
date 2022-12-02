defmodule RockPaperScissorsScorer do
  @score_rock 1
  @score_paper 2
  @score_scissors 3

  @score_loss 0
  @score_draw 3
  @score_win 6

  # Maps p2 move (A=rock, B=paper, C=scissors) to move
  # necessary to (X=lose, Y=draw, Z=win).
  @play %{
    "A" => %{"X" => "C", "Y" => "A", "Z" => "B"},
    "B" => %{"X" => "A", "Y" => "B", "Z" => "C"},
    "C" => %{"X" => "B", "Y" => "C", "Z" => "A"}
  }

  # Maps p2 move (A=rock, B=paper, C=scissors)
  #   to p1 move (A=rock, B=paper, C=scissors) 
  #   to -> score
  @score %{
    # p2: rock
    "A" => %{
      "A" => @score_rock + @score_draw,
      "B" => @score_paper + @score_win,
      "C" => @score_scissors + @score_loss
    },
    # p2: paper
    "B" => %{
      "A" => @score_rock + @score_loss,
      "B" => @score_paper + @score_draw,
      "C" => @score_scissors + @score_win
    },
    # p2: scissors
    "C" => %{
      "A" => @score_rock + @score_win,
      "B" => @score_paper + @score_loss,
      "C" => @score_scissors + @score_draw
    }
  }

  def scan_line(line, acc) do
    [_, p1, outcome] = Regex.run(~r{^([ABC]) ([XYZ])}, line)
    p2 = @play[p1][outcome]
    acc + @score[p1][p2]
  end

  def scan(input_file) do
    File.stream!(input_file)
    |> Enum.reduce(0, &scan_line/2)
  end
end

RockPaperScissorsScorer.scan("input.txt") |> IO.puts()
