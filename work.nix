{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    bitwarden-cli
    clang-tools_15
    cmake
    cmake-format
    darwin.lsusb
    dive
    ffmpeg_5
    flatbuffers
    git-repo
    gnupg
    gnutls
    glfw
    go
    gradle
    # hadolint
    htop
    jwt-cli
    llvmPackages_16.libllvm
    minicom
    poetry
    protobuf
    python310
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
