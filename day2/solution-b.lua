#!/usr/bin/env luajit

rock = 1
paper = 2
scissors = 3

loss = 0
draw = 3
win = 6

score = {}

score["A X"] = scissors + loss
score["A Y"] = rock + draw
score["A Z"] = paper + win

score["B X"] = rock + loss
score["B Y"] = paper + draw
score["B Z"] = scissors + win

score["C X"] = paper + loss
score["C Y"] = scissors + draw
score["C Z"] = rock + win

total = 0
for line in io.lines("input.txt") do
  total = total + score[line]
end

print(total)
