{
  pkgs,
  config,
  lib,
  ...
}: {
  # More tools are installed in per-repo devshells
  home.packages = with pkgs; [
    bitwarden-cli
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
    yamllint
  ];

  xdg.configFile."ideavim/ideavimrc".text = ''
    set clipboard+=unnamed
    set relativenumber number
  '';

  programs = {
    git.userEmail = lib.mkForce "cooper@humane.com";
  };
}
