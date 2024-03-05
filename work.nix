{ pkgs, config, lib, ... }:

{
  # More tools are installed in per-repo devshells
  home.packages = with pkgs; [
    bitwarden-cli
    darwin.lsusb
    dive
    ffmpeg_5
    flatbuffers
    git-repo
    gnupg
    gnutls
    glfw
    go
    # hadolint
    htop
    jwt-cli
    shellcheck
    shfmt
    teleport
    terraform
    terraform-docs
    unixtools.watch
    yamllint
  ];

  programs = {
    git.userEmail = lib.mkForce "cooper.pellaton@hu.ma.ne";
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
