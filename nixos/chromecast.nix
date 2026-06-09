{ pkgs, ... }:
{
  # to be able to access chromcast devices
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  networking.firewall.allowedTCPPorts = [ 8010 ];

  # actually casts
  environment.systemPackages = with pkgs; [ catt ];
}
