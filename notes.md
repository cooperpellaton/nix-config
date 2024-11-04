## fetchFromGithub
To calculate a valid block for a repo:

```sh
nix-shell -p nix-prefetch-github
nix-prefetch-github $owner $repo --nix
```

For example:

```sh
[nix-shell:~/Developer]$ nix-prefetch-github kidonng nix.fish --nix
let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "kidonng";
    repo = "nix.fish";
    rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
    hash = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
  }
```

## inspo + docs
* [Documentation.](https://nix-community.github.io/home-manager/index.xhtml)
* [Nix Storage optimization](https://nixos.wiki/wiki/Storage_optimization)
* [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world)
* [mitchellh's nixos-config](https://github.com/mitchellh/nixos-config)

## Maintaing Brewfile

Checkout this branch, rebase on main `grbom` and then:

```sh
rm -rf Brewfile && brew bundle dump
```
