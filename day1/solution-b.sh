#!/usr/bin/env bash

set -e -u -o pipefail

function scan_input {
    local acc=0

    while read line
    do
        case "${line:-}" in
            "")
                echo "$acc"
                acc=0
                ;;
            *)
                ((acc+=$line))
                ;;
        esac
    done < "input.txt"
}

function sum {
    local total=0

    while read line
    do
        ((total+=$line))
    done

    echo "$total"
}

scan_input | sort -n | tail -n 3 | sum
