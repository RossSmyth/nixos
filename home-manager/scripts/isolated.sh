#!/usr/bin/env -S bash -Eeuo pipefail

if [ $# -eq 0 ]; then
    echo "Error: No program provided."
    echo "To use:"
    echo "> isolated result/bin/thing --some-flag"
    echo ""
    echo "Only works for things in the Nix store."
    echo "The Nix store is mounted in the namespace, as it is not considered private."
    echo ""
    echo "Environment variables:"
    echo ""
    echo "\$WAYLAND := If set, passes the Wayland socket through."
    echo "\$USE_HOME := If set, mounts the \$HOME dir read-only and sets \$HOME"
    echo "\$NO_NETWORK := Defaults to 1, if explicitly set to 0 will disable the network namespace"
    echo "\$NO_DEVICES := Defaults to 1, if explicitly set to 0 will mount /dev/ into the namespace"
    exit 1
fi

bin="$(realpath "$1")"
shift

wayland=()
if [[ $WAYLAND && $WAYLAND_DISPLAY ]]; then
  wayland=("-p" "Environment=WAYLAND_DISPLAY=$WAYLAND_DISPLAY" "-p" "BindPaths=$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY")
  USE_HOME=1
fi

home=( "-p" "ProtectHome=1" )
if [[ $USE_HOME && $HOME ]]; then
  home=( "-p" "ProtectHome=read-only" "-p" "BindReadOnlyPaths=$(pwd)" "-p" "Environment=HOME=$HOME")
fi

# Runs something within an empty namespace so that program don't add their junk to my home dir >:(
# Not perfect at all. But sort of works.
exec systemd-run --pipe -v --wait --collect --user \
  "${wayland[@]}" \
  "${home[@]}" \
  -p RuntimeDirectory=isolated \
  -p RootDirectory="$XDG_RUNTIME_DIR/isolated" \
  -p BindPaths=/nix/store \
  -p RestrictSUIDSGID=1 \
  -p SystemCallArchitectures=native \
  -p ProtectProc=invisible \
  -p LockPersonality=1 \
  -p NoNewPrivileges=1 \
  -p PrivateMounts=1 \
  -p PrivateNetwork="${NO_NETWORK:-1}" \
  -p PrivateDevices="${NO_DEVICES:-1}" \
  -p PrivateIPC=1 \
  -p PrivatePIDs=1 \
  -p PrivateTmp=1 \
  -p PrivateUsers=1 \
  -p ProtectClock=1 \
  -p ProtectKernelLogs=1 \
  -p ProtectKernelModules=1 \
  -p ProtectHostname=1 \
  -p ProtectKernelTunables=1 \
  -p ProtectControlGroups=1 \
  -p RemoveIPC=1 \
  -p RestrictRealtime=1 \
  -p RestrictNamespaces=1 \
  -- "$bin" "$@"
