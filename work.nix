{ pkgs, config, lib, ... }:

{
  # have to do this for terraform
  nixpkgs.config.allowUnfree = true;

  # More tools are installed in per-repo devshells
  home.packages = with pkgs; [
    bitwarden-cli
    darwin.lsusb
    dive
    ffmpeg
    flatbuffers
    git-repo
    gnupg
    gnutls
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
