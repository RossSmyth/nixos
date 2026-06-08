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
      ./home-manager/minecraft.nix
      ./home-manager/ffmpeg.nix
    ];
    nixModules = [
      ./nixos/fonts.nix
      ./nixos/run0.nix
      ./nixos/sound.nix
      ./nixos/nvidia.nix
      ./nixos/bootloader.nix
      ./nixos/security.nix
      ./nixos/networking.nix
      ./nixos/niri.nix
      ./nixos/steam.nix
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
      ./home-manager/minecraft.nix
    ];
    nixModules = [
      ./nixos/battery.nix
      ./nixos/fonts.nix
      ./nixos/run0.nix
      ./nixos/sound.nix
      ./nixos/nvidia.nix
      ./nixos/bootloader.nix
      ./nixos/security.nix
      ./nixos/networking.nix
      ./nixos/niri.nix
    ];
  };
  trent = mkMachine {
    hostname = "trent";
    hmModules = [
      ./home-manager/mpv.nix
    ];
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
    ];
  };
}
