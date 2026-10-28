#!/usr/bin/env bash

pushd "$(dirname "$0")" || exit

host="$1"
shift

cmd="${1:-"dry-build"}"
shift

nixpkgs="$(npins get-path nixpkgs)"

nixos-rebuild "$cmd" -I nixpkgs="$nixpkgs" --elevate=run0 --ask-elevate-password --target-host "rsmyth@$host.home" --attr "$host" --show-trace "$@"
popd || exit
