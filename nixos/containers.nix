{ pkgs, ... }: {
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-test" ];
    externalInterface = "wlp0s20f3";
  };
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];

  containers.test = {
    autoStart = true;
    privateNetwork = true;

    hostAddress = "10.0.0.0";
    localAddress = "10.0.1.1";

    config = {
      imports = [
        ./security.nix
        ./run0.nix
        ./coreutils.nix
      ];

      services.caddy = {
        enable = true;
        openFirewall = true;
        logFormat = ''
          level DEBUG
        '';
        virtualHosts = {
          "10.0.1.1, test.containers".extraConfig = ''
            tls internal
            respond ":3"
          '';
        };
      };
    };
  };
}
