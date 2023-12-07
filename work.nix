{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    bitwarden-cli
    clang-tools_15
    cmake
    cmake-format
    dive
    ffmpeg_5
    flatbuffers
    git-repo
    gnupg
    gnutls
    glfw
    go
    google-cloud-sdk
    gradle
    # hadolint
    htop
    jwt-cli
    llvmPackages_16.libllvm
    minicom
    poetry
    protobuf
    shellcheck
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
