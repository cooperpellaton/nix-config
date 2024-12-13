{
  pkgs,
  lib,
  ...
}: let
  workEmail = "cooper@humane.com";
in {
  # More tools are installed in per-repo devshells
  home.packages = with pkgs; [
    darwin.lsusb
    dive
    ffmpeg
    git-repo
    gnupg
    gnutls
    go
    # hadolint
    jwt-cli
    pigz
    shellcheck
    shfmt
    teleport
    unixtools.watch
    uv
    yamllint
  ];

  programs = {
    git.userEmail = lib.mkForce workEmail;
    jujutsu.settings.user.email = lib.mkForce workEmail;
  };
}
