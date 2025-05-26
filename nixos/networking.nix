{ hostname, ... }:
{
  networking = {
    hostName = hostname;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
