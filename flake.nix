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

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      machine =
        {
          hostname,
          target ? "x86_64-linux",
          extraModules ? [ ],
          hmModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = target;
          specialArgs = {
            inherit inputs;
            inherit hostname;
          };
          modules = [
            ./.
            ./${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rsmyth = import ./home-manager;
              home-manager.extraSpecialArgs = {
                inherit inputs hostname;
                extraModules = hmModules;
              };
            }
          ] ++ extraModules;
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = {
        desktop = machine {
          hostname = "desktop";
        };
        work = machine {
          hostname = "work";
        };
        aurora = machine {
          hostname = "aurora";
          hmModules = [
            ./home-manager/alacritty.nix
            ./home-manager/wm.nix
            ./home-manager/gui.nix
          ];
        };
      };
    };
}
