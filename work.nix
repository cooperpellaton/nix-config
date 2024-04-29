{
  pkgs,
  config,
  lib,
  ...
}: {
  # have to do this for terraform
  nixpkgs.config.allowUnfree = true;

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
    terraform
    terraform-docs
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
