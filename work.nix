{
  pkgs,
  config,
  lib,
  ...
}: {
  # More tools are installed in per-repo devshells
  home.packages = with pkgs; [
    # re-enable when not broken
    # bitwarden-cli
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
    git.userEmail = lib.mkForce "cooper@humane.com";
    jujutsu.settings.user.email = lib.mkForce "cooper@humane.com";
  };
}
