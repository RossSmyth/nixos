{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Sway does not enable libinput by default.
  services.libinput.enable = true;

  # Automatically launch sway.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd ${lib.getExe pkgs.niri} ";
        user = "greeter";
      };
    };
  };

}
