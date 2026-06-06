#!/bin/env bash -eEuo
readonly input="$1"

readonly passlog="$(mktemp)"
trap 'rm -f -- "$passlog"' EXIT

# Why is ffmpeg obligated to outptu a bunch of garbage
echo "audioNorm: analyzing audio file..."
ffmpeg -hide_banner -nostats -i "$input" -filter:a loudnorm=print_format=json -f null null 2>&1 | awk '/{/,/}/' > "$passlog"
echo "audioNorm: analysis done."

readarray -t audioStats < <(cat "$passlog" | jq -r '.input_i, .input_lra, .input_tp, .target_offset')
readonly audioStats

readonly input_i="${audioStats[0]}"
readonly input_lra="${audioStats[1]}"
readonly input_tp="${audioStats[2]}"
readonly input_thresh="${audioStats[3]}"
readonly target_offset="${audioStats[3]}"

readonly outputPath="${input%.*}.normed.${input##*.}"

echo "audioNorm: normalizing file..."
ffmpeg -i "$input" -filter:a loudnorm=linear=true:i=-23.0:lra=7.0:tp=-2.0:offset="$target_offset":measured_I="$input_i":measured_tp="$input_tp":measured_LRA="$input_lra":measured_thresh="$input_thresh",aresample=resampler=soxr:out_sample_rate=48000:precision=28 "$outputPath"
