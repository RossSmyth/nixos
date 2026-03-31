#!/usr/bin/env bash

pushd "$(dirname $0)"
cmd="${1:-"dry-build"}"
shift

nixpkgs="$(npins get-path nixpkgs)"

pkexec --keep-cwd nixos-rebuild "$cmd" -I nixpkgs="$nixpkgs" --log-format internal-json --show-trace --attr "$(hostname)" "$@" |& nom --json
popd
