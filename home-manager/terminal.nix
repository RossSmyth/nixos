{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      window-decoration = "none";
      window-inherit-working-directory = false;
      linux-cgroup = "always";
      linux-cgroup-hard-fail = true;
      confirm-close-surface = false;
      font-size = 13;
      font-family = "Inconsolata Nerd Font Mono";
      font-family-bold = "Inconsolata Nerd Font Mono";
      font-family-italic = "Inconsolata Nerd Font Mono";
      font-family-bold-italic = "Inconsolata Nerd Font Mono";
    };
  };
}
