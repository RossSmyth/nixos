{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    settings = {
      trusted-users = ["rsmyth"];
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
      accept-flake-config = true;
      auto-optimise-store = true;
    };
    channel.enable = false;
    gc.automatic = true;
  };

  time.timeZone = "America/Detroit";
  systemd.coredump.enable = true;
  
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.pathsToLink = ["/share/fish"];
  environment.shells = [pkgs.fish];
  environment.enableAllTerminfo = true;

  programs.ssh.ciphers = ["chacha20-poly1305@openssh.com" "aes256-gcm@openssh.com"];
  programs.ssh.kexAlgorithms = ["curve25519-sha256@libssh.org" "curve25519-sha256"];

  users.users = {
    rsmyth = {
      useDefaultShell = true;
      hashedPassword = "$y$j9T$pANX.P1IbyQB2xriv3ncp/$AnA0t/0WrMitJYBivHKlcdp0d8lqbCuR0yN1zvOnDFA";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };
}
