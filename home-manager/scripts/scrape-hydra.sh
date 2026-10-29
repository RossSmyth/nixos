#!/usr/bin/env -S bash -Eeuo pipefail
local_nixpkgs="$1"

nix-eval-jobs --no-instantiate --force-recurse "$local_nixpkgs/pkgs/top-level/release.nix" 2> /dev/null \
| jaq -r '.drvPath | ltrimstr("/nix/store/")?' \
| parallel --jobs "${JOBS:-16}" --retries 3 wget -nc https://cache.nixos.org/log/{}
