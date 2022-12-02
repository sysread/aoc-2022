#!/usr/bin/env bash

set -e -u -o pipefail

function fail {
    echo "error: $*" >&2
    exit 1
}

SCORE_ROCK=1
SCORE_PAPER=2
SCORE_SCISSORS=3

SCORE_LOSS=0
SCORE_DRAW=3
SCORE_WIN=6

TOTAL=0

while read line
do
    case "${line:-}" in
        # p2: rock
        "A X") ((TOTAL+=$SCORE_ROCK + $SCORE_DRAW)) ;;
        "A Y") ((TOTAL+=$SCORE_PAPER + $SCORE_WIN)) ;;
        "A Z") ((TOTAL+=$SCORE_SCISSORS + $SCORE_LOSS)) ;;

        # p2: paper
        "B X") ((TOTAL+=$SCORE_ROCK + $SCORE_LOSS)) ;;
        "B Y") ((TOTAL+=$SCORE_PAPER + $SCORE_DRAW)) ;;
        "B Z") ((TOTAL+=$SCORE_SCISSORS + $SCORE_WIN)) ;;

        # p2: scissors
        "C X") ((TOTAL+=$SCORE_ROCK + $SCORE_WIN)) ;;
        "C Y") ((TOTAL+=$SCORE_PAPER + $SCORE_LOSS)) ;;
        "C Z") ((TOTAL+=$SCORE_SCISSORS + $SCORE_DRAW)) ;;

        *) fail "invalid input '$line'" ;;
    esac
done < "input.txt"

echo "$TOTAL"
