#!/usr/bin/env bash

set -e -u -o pipefail

MAX=0
ACC=0

while read line
do
    case "${line:-}" in
        "")
            if (($ACC > $MAX)); then
                MAX=$ACC
            fi
            ACC=0
            ;;
        *)
            ((ACC+=$line))
            ;;
    esac
done < "input.txt"

echo $MAX
