let
  inputs = import ./npins { };
  mkMachine = import ./mkMachine.nix inputs;
in
{
  desktop = mkMachine {
    hostname = "desktop";
    hmModules = [
      ./home-manager/terminal.nix
      ./home-manager/gui.nix
      ./home-manager/niri.nix
      ./home-manager/waybar.nix
      ./home-manager/mpv.nix
      ./home-manager/ffmpeg.nix
    ];
    nixModules = [
      ./nixos/fonts.nix
      ./nixos/run0.nix
      ./nixos/sound.nix
      ./nixos/nvidia.nix
      ./nixos/bootloader.nix
      ./nixos/security.nix
      ./nixos/wired.nix
      ./nixos/niri.nix
      ./nixos/steam.nix
      ./nixos/g920.nix
    ];
  };
  work = mkMachine {
    hostname = "work";
    nixModules = [
      ./nixos/fonts.nix
      ./nixos/wsl.nix
      ./nixos/tmpfsTmp.nix
    ];
  };
  riscy = mkMachine {
    target = "riscv64-linux";
    fromSource = false;
    hostname = "riscy";
    nixModules = [
      ./nixos/run0.nix
      ./nixos/bootloader.nix
      ./nixos/security.nix
      ./nixos/sshd.nix
    ];
  };
  aurora = mkMachine {
    hostname = "aurora";
    hmModules = [
      ./home-manager/terminal.nix
      ./home-manager/gui.nix
      ./home-manager/niri.nix
      ./home-manager/waybar.nix
      ./home-manager/mpv.nix
    ];
    nixModules = [
      ./nixos/battery.nix
      ./nixos/fonts.nix
      ./nixos/run0.nix
      ./nixos/sound.nix
      ./nixos/nvidia.nix
      ./nixos/bootloader.nix
      ./nixos/security.nix
      ./nixos/wireless.nix
      ./nixos/niri.nix
    ];
  };
  trent = mkMachine {
    hostname = "trent";
    nixModules = [
      ./nixos/agenix.nix
      ./nixos/fonts.nix
      ./nixos/run0.nix
      ./nixos/sound.nix
      ./nixos/nvidia.nix
      ./nixos/bootloader.nix
      ./nixos/security.nix
      ./nixos/sshd.nix
      ./nixos/torrent.nix
      ./nixos/networking.nix
      ./nixos/jellyfin.nix
      ./nixos/cuda.nix
      ./nixos/cats.nix
      ./nixos/silly.nix
      ./nixos/caddy.nix
    ];
  };
  jammy = mkMachine {
    hostname = "jammy";
    nixModules = [
      ./nixos/agenix.nix
      ./nixos/fonts.nix
      ./nixos/run0.nix
      ./nixos/sound.nix
      ./nixos/bootloader.nix
      ./nixos/networking.nix
      ./nixos/security.nix
      ./nixos/sshd.nix
      ./nixos/zfs.nix
      ./nixos/caddy.nix
      ./nixos/cats.nix
      ./nixos/silly.nix
      ./nixos/immich.nix
      ./nixos/lidarr.nix
      ./nixos/navidrome.nix
      ./nixos/adguard.nix
    ];
  };
}
