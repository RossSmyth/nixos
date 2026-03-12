inputs:
let
  evalConfig = import (inputs.nixpkgs + "/nixos/lib/eval-config.nix");
in
{
  hostname,
  target ? "x86_64-linux",
  build ? builtins.currentSystem or "x86_64-linux",
  nixModules ? [ ],
  hmModules ? [ ],
  user ? "rsmyth",
}:
evalConfig {
  system = null;
  specialArgs = {
    inherit inputs hostname user;
  };
  modules = [
    ./nixos
    ./machines/${hostname}
    {
      nixpkgs.buildPlatform = build;
      nixpkgs.hostPlatform = target;
    }
    (inputs.home-manager + "/nixos")
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ./home-manager hmModules;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          hostname
          user
          ;
      };
    }
  ]
  ++ nixModules;
}
