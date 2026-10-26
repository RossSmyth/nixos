#!/usr/bin/env bash
set +Eeuo pipefail

pushd "$(dirname "$0")" || exit
cmd="${1:-"dry-build"}"
shift

nixpkgs="$(npins get-path nixpkgs)"

elevCmd=""
run_diff=false
case "$cmd" in
  switch|boot|test)
    if command -v sudo &> /dev/null; then
      echo "Warning: Using sudo, not run0"
      elevCmd="sudo"
    else
      elevCmd="run0"
    fi
    run_diff=true
    ;;
  *)
    elevCmd="command"
    ;;
esac

"$elevCmd" nixos-rebuild "$cmd" -I nixpkgs="$nixpkgs" --log-format internal-json --show-trace --attr "$(hostname)" "$@" |& nom --json
popd || exit

if $run_diff; then
  dix /run/booted-system /run/current-system || true
fi
