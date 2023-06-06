{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    awscli2
    bitwarden-cli
    clang-tools_15
    cmake
    cmake-format
    dive
    ffmpeg_5
    flatbuffers
    gnupg
    gnutls
    glfw
    go
    google-cloud-sdk
    gradle
    hadolint
    htop
    jwt-cli
    minicom
    opencv
    protobuf
    shellcheck
    terraform
    terraform-docs
    yamllint
  ];

  programs.git.userEmail = lib.mkForce "cooper.pellaton@hu.ma.ne";
}
