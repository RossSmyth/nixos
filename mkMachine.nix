inputs:
{
  hostname,
  target ? "x86_64-linux",
  nixModules ? [ ],
  hmModules ? [ ],
  user ? "rsmyth",
  local ? true,
}:
{
  meta = {
    nodeNixpkgs.${hostname} = import inputs.nixpkgs {
      system = target;
    };

    nodeSpecialArgs.${hostname} = {
      inherit inputs hostname user;
    };
  };

  ${hostname} = {
    deployment = {
      allowLocalDeployment = local;
      targetHost = if local then null else hostname;
    };

    imports = [
      ./nixos
      ./machines/${hostname}
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import ./home-manager hmModules;
        home-manager.extraSpecialArgs = {
          inherit inputs hostname user;
        };
      }
    ]
    ++ nixModules;
  };
}
