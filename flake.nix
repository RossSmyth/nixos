{
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

    helix.url = "github:RossSmyth/helix/nixRisc";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    ripgrep = {
      url = "github:burntsushi/ripgrep";
      flake = false;
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      colmena,
      ...
    }@inputs:
    let
      mkMachine = import ./mkMachine.nix inputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      colmenaHive = colmena.lib.makeHive (
        {
          meta = {
            nixpkgs = import nixpkgs {
              system = "x86_64-linux";
            };
            nodeSpecialArgs.desktop = {
              inherit inputs;
              user = "rsmyth";
              hostname = "desktop";
            };
            nodeSpecialArgs.work = {
              inherit inputs;
              user = "rsmyth";
              hostname = "work";
            };
            nodeSpecialArgs.aurora = {
              inherit inputs;
              user = "rsmyth";
              hostname = "aurora";
            };
            nodeSpecialArgs.riscy = {
              inherit inputs;
              user = "rsmyth";
              hostname = "riscy";
            };
          };

        }
        // (nixpkgs.lib.mergeAttrsList [
          (mkMachine {
            hostname = "desktop";
            nixModules = [
              ./nixos/wsl.nix
              ./nixos/tmpfsTmp.nix
            ];
          })
          (mkMachine {
            hostname = "work";
            nixModules = [
              ./nixos/wsl.nix
              ./nixos/tmpfsTmp.nix
            ];
          })
          (mkMachine {
            hostname = "riscy";
            nixModules = [
              ./nixos/run0.nix
              ./nixos/bootloader.nix
              ./nixos/security.nix
              ./nixos/sshd.nix
            ];
            deployment = {
              buildOnTarget = true;
            };
          })
          (mkMachine {
            hostname = "aurora";
            hmModules = [
              ./home-manager/alacritty.nix
              ./home-manager/gui.nix
              ./home-manager/niri.nix
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
              ./nixos/battery.nix
              ./nixos/niri.nix
            ];
          })
        ])
      );
    };
}
