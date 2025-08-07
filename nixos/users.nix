{ user, ... }:
{
  users.mutableUsers = false;

  users.users.${user} = {
    useDefaultShell = true;
    hashedPassword = "$y$j9T$pANX.P1IbyQB2xriv3ncp/$AnA0t/0WrMitJYBivHKlcdp0d8lqbCuR0yN1zvOnDFA";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "audio"
      "docker"
    ];
  };
}
