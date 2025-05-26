_: {
  # Required for Run0 & Sway
  security.polkit.enable = true;

  # Only use the good stuff
  programs.ssh.ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes256-gcm@openssh.com"
  ];
  programs.ssh.kexAlgorithms = [
    "curve25519-sha256@libssh.org"
    "curve25519-sha256"
  ];
}
