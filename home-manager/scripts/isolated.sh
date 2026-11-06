#!/usr/bin/env -S bash -Eeuo pipefail

bin="$(realpath "$1")"
shift

wayland=()
if [[ $WAYLAND ]]; then
  wayland=("-p" "Environment=WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}" "-p" "BindPaths=$XDG_RUNTIME_DIR/${WAYLAND_DISPLAY:-}")
fi

home=("-p" "ProtectHome=1")
if [[ $HOME ]]; then
  home=("--same-dir" "-p" "ProtectHome=tmpfs")
fi

# Runs something within an empty namespace so that program don't add their junk to my home dir >:(
# Not perfect at all. But sort of works.
exec systemd-run --pipe -v --wait --collect --user \
  -p RuntimeDirectory=isolated \
  -p RootDirectory="$XDG_RUNTIME_DIR/isolated" \
  "${wayland[@]}" \
  -p BindPaths=/nix/store \
  -p RestrictSUIDSGID=1 \
  -p SystemCallArchitectures=native \
  -p ProtectProc=invisible \
  -p LockPersonality=1 \
  -p NoNewPrivileges=1 \
  -p PrivateMounts=1 \
  -p PrivateDevices="${DEVICES:-1}" \
  -p PrivateIPC=1 \
  -p PrivatePIDs=1 \
  -p PrivateTmp=1 \
  -p PrivateUsers=1 \
  -p ProtectClock=1 \
  "${home[@]}" \
  -p ProtectKernelLogs=1 \
  -p ProtectKernelModules=1 \
  -p ProtectHostname=1 \
  -p ProtectKernelTunables=1 \
  -p ProtectControlGroups=1 \
  -p RemoveIPC=1 \
  -p RestrictRealtime=1 \
  -p RestrictNamespaces=1 \
  -- "$bin" "$@"
