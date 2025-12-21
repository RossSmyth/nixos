{ pkgs, ... }:
{
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = [
        pkgs.jdk
      ];
    })
  ];
}
