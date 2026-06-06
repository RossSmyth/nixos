#!/bin/env bash -eEuo
readonly input="$1"
readonly output="$2"

# 2-pass data file
readonly passlog="$(mktemp)"
trap 'rm -f -- "$passlog"' EXIT

ffmpeg -y -i "$input" -c:v libx264 -b:v 4M -pass 1 -passlogfile "$passlog" -an -f mp4 null
ffmpeg -i "$input" -c:v libx264 -b:v 4M -pass 2 -passlogfile "$passlog" -c:a aac "$output"
