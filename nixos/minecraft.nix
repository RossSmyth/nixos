{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    "${inputs.nix-minecraft}/modules/minecraft-servers.nix"
  ];

  nixpkgs.overlays = [
    (import "${inputs.nix-minecraft}/overlay.nix")
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft";

    managementSystem = {
      systemd-socket.enable = true;
      tmux.enable = false;
    };

    servers.gtnh = rec {
      enable = true;
      package = pkgs.callPackage ./gtnh.nix { };
      jvmOpts = "-Xmx8G -Xms8G";
      serverProperties = {
        level-type = "rwg";
        difficulty = 3;
        allow-flight = true;
      };
      symlinks.mods = "${package}/lib/mods";
      files.config = "${package}/lib/config";
    };
  };

  users.users.minecraft.createHome = lib.mkForce false;
}
