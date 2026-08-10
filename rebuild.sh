#!/usr/bin/env bash

pushd "$(dirname "$0")" || exit
cmd="${1:-"dry-build"}"
shift

nixpkgs="$(npins get-path nixpkgs)"

elevCmd=""
case "$cmd" in
  switch|boot|test)
    if command -v sudo &> /dev/null; then
      echo "Warning: Using sudo, not run0"
      elevCmd="sudo"
    else
      elevCmd="run0"
    fi
    ;;
  *)
    ;;
esac

"$elevCmd" nixos-rebuild "$cmd" -I nixpkgs="$nixpkgs" --log-format internal-json --show-trace --attr "$(hostname)" "$@" |& nom --json
popd || exit
