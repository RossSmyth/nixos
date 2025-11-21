{ user, ... }:
{
  # Configure users with a Rust program, not an ad-hoc perl script
  services.userborn.enable = true;

  users.mutableUsers = false;

  users.users.${user} = {
    useDefaultShell = true;
    hashedPassword = "$y$j9T$pANX.P1IbyQB2xriv3ncp/$AnA0t/0WrMitJYBivHKlcdp0d8lqbCuR0yN1zvOnDFA";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "docker"
    ];
  };
}
