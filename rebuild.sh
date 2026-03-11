#!/usr/bin/env bash

pushd "$(dirname $0)"
cmd="${1:-"dry-build"}"
shift

nixpkgs="$(, npins get-path nixpkgs)"

NIX_PATH="nixpkgs=$nixpkgs" nixos-rebuild "$cmd" --attr "$(hostname)" "$@"
popd
