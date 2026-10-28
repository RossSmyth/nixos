#!/usr/bin/env -S bash -Eeuo pipefail
pr_number="$1"

curl -sfL "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/$pr_number.patch" | patch -p1
