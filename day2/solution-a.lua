#!/usr/bin/env luajit

rock = 1
paper = 2
scissors = 3

loss = 0
draw = 3
win = 6

score = {}

score["A X"] = rock + draw
score["A Y"] = paper + win
score["A Z"] = scissors + loss

score["B X"] = rock + loss
score["B Y"] = paper + draw
score["B Z"] = scissors + win

score["C X"] = rock + win
score["C Y"] = paper + loss
score["C Z"] = scissors + draw

total = 0
for line in io.lines("input.txt") do
  total = total + score[line]
end

print(total)
