{ pkgs, ... }: {
  home.username = "cooper";
  home.homeDirectory = "/Users/cooper";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = [
    #pkgs.avrdude
    pkgs.coreutils
    pkgs.curl
    pkgs.exa
    pkgs.fortune
    pkgs.fzf
    pkgs.jq
    pkgs.mosh
    pkgs.nixfmt
    pkgs.openssl
    #pkgs.qmk
    pkgs.ripgrep
    pkgs.rsync
    pkgs.tree
    pkgs.wget
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Solarized (dark)";
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
        map-syntax = [ ".ignore:Git Ignore" "h:cpp" ];
      };
    };
    git = {
      enable = true;
      userName = "Cooper Pellaton";
      userEmail = "c@cepp.ch";
      extraConfig = {
        credential.helper = "store";
        merge.conflictstyle = "diff3";
        rerere.enabled = 1;
        color.ui = true;
        push.default = "tracking";
        diff.renames = "copies";
        diff.mnemonicprefix = true;
        diff.compactionHeuristic = true;
        rebase.autoStash = true;
        fetch.prune = true;
        pager.diff = "delta";
        pager.log = "delta";
        pager.reflog = "delta";
        pager.show = "delta";
        url = {
          "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
        };
      };
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          plus-style = "syntax #012800";
          minus-style = "syntax #340001";
          syntax-theme = "Solarized (dark)";
          navigate = true;
        };
      };
      lfs = { enable = true; };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          fortune
        end
      '';
      plugins = [
        {
          name = "hydro";
          src = pkgs.fishPlugins.hydro.src;
        }
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
        {
          name = "plugin-git";
          src = pkgs.fetchFromGitHub {
            owner = "jhillyerd";
            repo = "plugin-git";
            rev = "0d597a23ce2e9a067131effca5aeb1a1068de0d0";
            sha256 = "0c9pm6n6kmad2fih4rlq1sj4p8cng0xjlshba944pv93sx0x3yii";
          };
        }
      ];
      shellAliases = { rm = "rm -i"; };
      shellAbbrs = { ip = "curl icanhazip.com"; };
    };
    tmux = {
      enable = true;
      terminal = "xterm-256color";
      extraConfig = ''
        # remap prefix from 'C-b' to 'C-a'
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        # switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # key remapping for naming
        set-window-option -g automatic-rename on
        bind-key n command-prompt 'rename-window %%'
        bind-key N command-prompt 'rename-session %%'
      '';
    };
  };
}
