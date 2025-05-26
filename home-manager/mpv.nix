{ pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      cursor-autohide = 100;
      keep-open = "yes";
      terminal = "yes";
      reset-on-next-file = "profile";
      input-gamepad = "yes";

      # Screenshots
      screenshot-format = "png";
      screenshot-tag-colorspace = "yes";

      # Audio
      ao = "pipewire";
      audio-exclusive = "no";
      audio-file-auto = "fuzzy";
      volume-max = 100;

      # Streaming
      ytdl-format = "bestvideo[height<=?2160]+bestaudio/best";

      # Subs
      sub-auto = "fuzzy";
      slang = "eng,en";
      alang = "ja,jp,jpn,en,eng";
      demuxer-mkv-subtitle-preroll = "yes";
      sub-fix-timing = "no";
      sub-ass-vsfilter-blur-compat = "no";
      #sub-ass-force-margins=no #@CTR's Lyrical Nanoha

      # Simulcast sub override
      sub-ass-override = "no";
      sub-font = "LTFinnegan";
      sub-font-size = 50;
      sub-bold = "yes";
      sub-color = "#FFFFFF";
      sub-border-size = 2.4;
      sub-border-color = "#FF000000";
      sub-shadow-color = "#A0000000";
      sub-shadow-offset = 0.75;

      # Video
      profile = "gpu-hq";
      vo = "gpu-next";
      gpu-api = "vulkan";
      volume = 100;
      vulkan-async-compute = "yes";
      vulkan-async-transfer = "yes";
      screen = 0;

      # Dither
      dither-depth = "auto";
      dither = "error-diffusion";
      error-diffusion = "stucki";
      temporal-dither = "yes";

      # Deband
      deband = "no";
      deband-iterations = 4;
      deband-threshold = 48;
      deband-grain = 12;

      # Luma Upscaler
      fbo-format = "rgba16hf";
      no-scaler-resizes-only = null;
      scale = "ewa_lanczos";
      scale-blur = 1.11;
      scale-radius = 3.2383154841662362;
      scale-window = "hanning";
      glsl-shaders-append = "~~/Shaders/FSRCNNX_x2_16-0-4-1.glsl";

      # Chroma scalers
      glsl-shaders-append = "~~/Shaders/SSimSuperRes.glsl";
      glsl-shaders-append = "~~/Shaders/SSimDownscaler.glsl";
      dscale = "mitchell";
      linear-downscaling = "no";

      # Chroma scaler
      glsl-shaders-append = "~~/Shaders/KrigBilateral.glsl";
      cscale = "catmull_rom";
      sigmoid-upscaling = "yes";

      # Antiringing
      scale-antiring = 0.7;
      dscale-antiring = 0.7;
      cscale-antiring = 0.7;

      # Reclock
      video-sync = "display-resample";
    };

    scripts = with pkgs.mpvScripts; [
      autocrop
      autoload
      # easycrop
      mpv-playlistmanager
      # titleresolver
      mpv-webm
    ];

    scriptOpts = {
      # TODO
    };

    bindings = {
      AXIS_UP = "add volume 1";
      AXIS_DOWN = "add volume -1";
      "Alt+s" = "playlist-shuffle";
      MBTN_LEFT = "cycle pause";
      RIGHT = "seek 3";
      LEFT = "seek -3";

      MBTN_FORWARD = "add sub-delay 0.001";
      MBTN_BACK = "add sub-delay -0.001";

      "Alt+p" = "script-message playlistmanager save";

      h = "cycle deband";
      g = "cycle audio-exclusive";
    };

    profiles =
      let
        music = [
          "no-video"
          "no-osc"
          "replaygain=album"
        ];
      in
      {
        "extension.flac" = music;
        "extension.mp3" = music;
        "extension.ogg" = music;

        simulcast = {
          profile-desc = "Auto-override: True";
          glsl-shaders-append = /shaders/noise_static_luma.hook;
          deband = "yes";
          sub-ass-override = "force";
          sub-fix-timings = "yes";
          sub-ass-force-style = "Kerning=yes";
        };

        simulcast-no = {
          profile-desc = "Auto-override: False";
          glsl-shaders-remove = /shaders/noise_static_luma.hook;
          deband = "no";
          sub-ass-override = "no";
          sub-fix-timing = "no";
          sub-ass-force-margins = "no";
          sub-ass-force-style = "Kerning=no";
        };
        # Autoprofiles
      };
  };
}
