inputs:
{
  hostname,
  target ? "x86_64-linux",
  nixModules ? [ ],
  hmModules ? [ ],
}:
inputs.nixpkgs.lib.nixosSystem {
  system = target;
  specialArgs = {
    inherit inputs;
    inherit hostname;
  };
  modules = [
    ./nixos
    ./${hostname}
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rsmyth = import ./home-manager;
      home-manager.extraSpecialArgs = {
        inherit inputs hostname;
        extraModules = hmModules;
      };
    }
  ] ++ nixModules;
}
