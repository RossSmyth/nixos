{ pkgs, lib, ... }: {
  programs.beets = {
    enable = true;

    settings = {
      directory = "/media/lib/music";

      import = {
        write = true;
        copy = true;
        resume = "ask";
      };

      paths = {
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "Non-Album/$artist/$title";
        comp = "Compilations/$album%aunique{}/$track $title";
      };

      plugins = [
        "replaygain"
        "fetchart"
        "musicbrainz"
      ];

      fetchart = {
        cautious = true;
        cover_names = "cover front art album folder";
        sources = [
          "filesystem"
          { coverart = "release releasegroup"; }
        ];
      };

      replaygain = {
        backend = "ffmpeg";
        command = lib.getExe pkgs.ffmpeg-headless;
      };

      musicbrainz = {
        host = "musicbrainz.org";
        https = true;
        ratelimit = 1;
        ratelimit_interval = 1.0;
        extra_tags = [
          "alias"
          "year"
          "tracks"
        ];
        genres = true;
        external_ids = {
          discogs = true;
          spotify = true;
          bandcamp = true;
        };
      };
    };
  };
}
