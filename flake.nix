{
  nixConfig = {
    extra-substituters = [ "https://helix.cachix.org" ];
    extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
  };
  inputs = {
    nixpkgs.url = "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      mkMachine = import ./mkMachine.nix inputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations = {
        desktop = mkMachine {
          hostname = "desktop";
          hmModules = [
            ./home-manager/ghostty.nix
            ./home-manager/gui.nix
            ./home-manager/niri.nix
            ./home-manager/waybar.nix
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
            ./nixos/chromecast.nix
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
            ./home-manager/ghostty.nix
            ./home-manager/gui.nix
            ./home-manager/niri.nix
            ./home-manager/waybar.nix
          ];
          nixModules = [
            ./nixos/fonts.nix
            ./nixos/run0.nix
            ./nixos/sound.nix
            ./nixos/battery.nix
            ./nixos/nvidia.nix
            ./nixos/bootloader.nix
            ./nixos/security.nix
            ./nixos/networking.nix
            ./nixos/niri.nix
            ./nixos/chromecast.nix
          ];
        };
      };
    };
}
