#!/bin/env bash -eEuo
readonly input="$1"

readonly output="${file%.*}.mp3"

ffmpeg -i "$input" "$output"
