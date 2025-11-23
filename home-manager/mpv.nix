{ pkgs, ... }:
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
      no-scaler-resizes-only = true;
      scale = "ewa_lanczos";
      scale-blur = 1.11;
      scale-radius = 3.2383154841662362;
      scale-window = "hanning";
      glsl-shaders-append = builtins.map builtins.toString [
        "~~/Shaders/FSRCNNX_x2_16-0-4-1.glsl"
        (pkgs.fetchurl {
          name = "FSRCNNX_x2_16-0-4-1.glsl";
          url = "https://github.com/igv/FSRCNN-TensorFlow/releases/download/1.1/FSRCNNX_x2_16-0-4-1.glsl";
          hash = "sha256-1aJKJx5dmj9/egU7FQxGCkTCWzz393CFfVfMOi4cmWU=";
        })
        (pkgs.fetchurl {
          name = "SSimSuperRes.glsl";
          url = "https://gist.github.com/igv/2364ffa6e81540f29cb7ab4c9bc05b6b/raw/15d93440d0a24fc4b8770070be6a9fa2af6f200b/SSimSuperRes.glsl";
          hash = "sha256-qLJxFYQMYARSUEEbN14BiAACFyWK13butRckyXgVRg8=";
        })
        (pkgs.fetchurl {
          name = "SSimDownscaler.glsl";
          url = "https://gist.github.com/igv/36508af3ffc84410fe39761d6969be10/raw/38992bce7f9ff844f800820df0908692b65bb74a/SSimDownscaler.glsl";
          hash = "sha256-9G9HEKFi0XBYudgu2GEFiLDATXvgfO9r8qjEB3go+AQ=";
        })
        (pkgs.fetchurl {
          name = "KrigBilateral.glsl";
          url = "https://gist.github.com/igv/a015fc885d5c22e6891820ad89555637/raw/038064821c5f768dfc6c00261535018d5932cdd5/KrigBilateral.glsl";
          hash = "sha256-ikeYq7d7g2Rvzg1xmF3f0UyYBuO+SG6Px/WlqL2UDLA=";
        })
      ];

      # Chroma scalers
      dscale = "mitchell";
      linear-downscaling = "no";

      # Chroma scaler
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
      easycrop
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
        music = {
          no-video = true;
          no-osc = true;
          replaygain = "album";
        };

        staticLuma = builtins.toString (
          pkgs.fetchurl {
            name = "noise_static_luma.hook";
            url = "https://github.com/wopian/mpv-config/raw/69fd36f54e51d1c9dfef90436027d1237e757141/shaders/noise_static_luma.hook";
            hash = "sha256-3cu2RBFlF4fw+X7FfhdhPNU38/DhhLJN6fl1PxaewNE=";
          }
        );
      in
      {
        "extension.flac" = music;
        "extension.mp3" = music;
        "extension.ogg" = music;

        simulcast = {
          profile-desc = "Auto-override: True";
          glsl-shaders-append = staticLuma;
          deband = "yes";
          sub-ass-override = "force";
          sub-fix-timings = "yes";
          sub-ass-force-style = "Kerning=yes";
        };

        simulcast-no = {
          profile-desc = "Auto-override: False";
          glsl-shaders-remove = staticLuma;
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
