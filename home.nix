{
  config,
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  doomPath = "${config.home.homeDirectory}/.config/home-manager/doom";
in {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    curl
    eza
    fzf
    gh
    glow
    jq
    mosh
    nil
    nixd
    pre-commit
    python312
    python312Packages.ipython
    ripgrep
    rustup
    rsync
    tio
    tlrc
    uutils-coreutils-noprefix
    zoxide
  ];

  xdg.configFile = {
    # ht https://nixos-and-flakes.thiscute.world/best-practices/accelerating-dotfiles-debugging
    "doom".source = config.lib.file.mkOutOfStoreSymlink doomPath;
    "ghostty/config".text = ''
      font-family = Berkeley Mono
      font-size = 14
      theme = dark:Solarized Dark Higher Contrast,light:flexoki-light
      cursor-style = bar
    '';
    "ideavim/ideavimrc".text = ''
      set clipboard+=unnamed
      set relativenumber number
    '';
    "zed/settings.json".source = ./zed_settings.json;
    "zellij/layouts/minimal.kdl".text = ''
      layout {
        pane
        pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
        }
    '';
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Solarized (dark)";
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
        map-syntax = [".ignore:Git Ignore" "h:cpp"];
      };
      extraPackages = with pkgs.bat-extras; [batman];
    };
    btop = {
      enable = true;
      settings = {color_theme = "solarized_dark";};
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    emacs = {
      enable = true;
    };
    fish = {
      enable = true;
      plugins =
        map (n: {
          name = n;
          src = pkgs.fishPlugins.${n}.src;
        }) ["hydro" "plugin-git" "sponge" "foreign-env"]
        ++ [
          {
            name = "nix-fish";
            src = pkgs.fetchFromGitHub {
              owner = "kidonng";
              repo = "nix.fish";
              rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
              hash = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
            };
          }
        ];
      shellAliases = {
        rm = "rm -i";
        ls = "eza";
        la = "eza -la";
        ll = "eza -ll";
      };
      shellAbbrs = {ec = "emacsclient -nw -c -a 'emacs'";};
      loginShellInit = "zoxide init fish | source";
      interactiveShellInit =
        ''
          fish_add_path ~/.config/emacs/bin
          batman --export-env | source
        ''
        + lib.optionalString isDarwin ''
          fish_add_path /opt/homebrew/bin
        '';
    };
    git = {
      enable = true;
      userName = "Cooper Pellaton";
      userEmail = "c@cepp.ch";
      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        credential.helper = "store";
        diff.renames = "copies";
        diff.mnemonicprefix = true;
        diff.compactionHeuristic = true;
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.default = "tracking";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        rerere.enabled = 1;
        submodule.recurse = true;
        url = {
          "ssh://git@github.com/" = {insteadOf = "https://github.com/";};
        };
      };
      difftastic = {
        enable = true;
      };
      lfs = {enable = true;};
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Cooper Pellaton";
          email = "c@cepp.ch";
        };
      };
    };
    neovim = let
      vimConfig = (import ./vim.nix) {inherit pkgs;};
    in {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
      extraConfig = vimConfig.config;
      plugins = vimConfig.plugins;
    };
    zellij = {
      enable = true;
      settings = {
        theme = "solarized-dark";
        ui = {
          pane_frames = {
            rounded_corners = true;
            hide_session_name = true;
          };
        };
        default_layout = "minimal";
      };
    };
  };
  # Emacs daemon
  # services.emacs.enable = true;
}
