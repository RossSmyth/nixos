{
  # Required for Run0 & Sway
  security = {
    # Essentially disable kexec.
    # I never use kexec and do not plan on it.
    protectKernelImage = true;

    polkit.enable = true;

    # Another SUID bites the dust
    wrappers.pkexec.enable = false;
  };

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
