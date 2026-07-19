{ lib, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  rsmyth.backups.enable = true;

  # It is a laptop server
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  # https://developer.nvidia.com/video-encode-decode-support-matrix
  # 1060 mobile
  # Hardware specific
  hardware.nvidia.open = lib.mkForce false;
  hardware.nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;
  services.jellyfin = {
    hardwareAcceleration = {
      enable = true;
      type = "nvenc";
      device = "/dev/dri/renderD129";
    };

    transcoding = {
      enableHardwareEncoding = true;

      hardwareDecodingCodecs = {
        av1 = false;
        h264 = true; # Only 8-bit and not 4:2:2
        hevc = true;
        hevc10bit = true;
        hevcRExt10bit = false;
        hevcRExt12bit = false;
        mpeg2 = true;
        vc1 = true;
        vp8 = false;
        vp9 = true; # Only 8-bit
      };
      hardwareEncodingCodecs = {
        # mpeg2 = null; unknown, not in matrix
        # vc1 = null; unknown, not in matrix
        # vp8 = null; unknown, not in matrix
        # vp9 = null; unknown, not in matrix
        av1 = false;
        hevc = true;
      };
    };
  };
}
