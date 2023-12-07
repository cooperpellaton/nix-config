## fetchFromGithub
To calculate a valid block for a repo:

```sh
nix-shell -p nix-prefetch-github
nix-prefetch-github owner repo --nix
```

For example:

```sh
[nix-shell:~/Developer/nix-prefetch]$ nix-prefetch-github kidonng kidonng --nix
let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "kidonng";
    repo = "kidonng";
    rev = "9578c80e6c1eeb5350ea91be417fab0cd16849ca";
    hash = "sha256-8voSACANtI4XaD1NRdueptSCu/0VqOejRLFuBtjOSoc=";
  }

```
