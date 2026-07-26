#!/usr/bin/env bash

pushd "$(dirname "$0")" || exit

host="$1"
shift

cmd="${1:-"dry-build"}"
shift

nixpkgs="$(npins get-path nixpkgs)"

# Since we are building on a machine that is not the target, we
# do not have these as substituters
cudaFlags=("--option" "extra-substituters" "https://cache.flox.dev" "--option" "extra-trusted-public-keys" "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=")

nixos-rebuild "$cmd" -I nixpkgs="$nixpkgs" --use-substitutes "${cudaFlags[@]}" --elevate=run0 --ask-elevate-password --target-host "rsmyth@$host.local" --attr "$host" --show-trace "$@"
popd || exit
