{
  config,
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  doomPath = "${config.home.homeDirectory}/.config/home-manager/doom";
in {
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
      theme = dark:Solarized Dark Higher Contrast,light:rose-pine-dawn
      cursor-style = bar
    '';
    "ideavim/ideavimrc".text = ''
      set clipboard+=unnamed
      set relativenumber number
    '';
    "zed/settings.json".text = ''
      {
        "telemetry": {
          "metrics": false
        },
        "theme": {
            "mode": "system",
            "light": "Solarized Light",
            "dark": "Solarized Dark",
        },
        "buffer_font_size": 14,
        "buffer_font_family": "Berkeley Mono",
        "vim_mode": true,
        "vim": {
          "toggle_relative_line_numbers": true
        },
        "soft_wrap": "preferred_line_length",
        "assistant": {
            "version": "2",
            "enabled": true,
            "default_model": {
                "provider": "ollama",
                "model": "llama3.2:latest"
            }
        },
        "auto_install_extensions": {
          "git_firefly": true
        }
      }
    '';
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
        lib.mkIf isDarwin
        ''
          fish_add_path /opt/homebrew/bin
          batman --export-env | source
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
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
      extraConfig = ''
        """""""""""
        " GENERAL "
        """""""""""
        set clipboard=unnamed
        set number relativenumber
        augroup numbertoggle
          autocmd!
          autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
          autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
        augroup END
        syntax on
        set t_Co=256
        " Fix backspace so that it works normally
        set backspace=indent,eol,start
        " Show existing tab with 2 spaces width
        set tabstop=2
        " Copy indent from current line when starting a new line.
        set autoindent
        " when indenting with '>', use 2 spaces width
        set shiftwidth=2
        " On pressing tab, insert 2 spaces
        set expandtab
        " Turn case sensitive search off and smartcase search on
        set ignorecase
        set smartcase
        " Fold based on syntax
        set foldmethod=syntax
        " Don't fold files by default
        set nofoldenable
        " Don't show the current mode on the last line (status line displays the current mode)
        set noshowmode
        " Limit the completion menu to 10 entries
        set pumheight=10
        " pres // to stop highlighting results
        nmap <silent> // :nohlsearch<CR>

        """""""""""""""
        " Indent Line "
        """""""""""""""
        " Change the characters recursively
        let g:indentLine_char_list = ['|', '¦', '┆', '┊']

        """""""""""""""""
        " WINDOW CONFIG "
        """""""""""""""""
        " quicker window movement
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-h> <C-w>h
        nnoremap <C-l> <C-w>l

        " open new split panes to right and bottom, which feels more natural
        set splitbelow
        set splitright
      '';
      plugins = with pkgs.vimPlugins; [
        vim-fugitive
        supertab
        {
          plugin = lightline-vim;
          config = ''
            let g:lightline = {
                  \ 'colorscheme': 'selenized_dark',
                  \ 'active': {
                  \   'left': [ [ 'mode', 'paste' ],
                  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
                  \ },
                  \ 'component_function': {
                  \   'gitbranch': 'FugitiveHead'
                  \ },
                  \ }
          '';
        }
        vim-gitgutter
        vim-wordmotion
        vim-endwise
        float-preview-nvim
        {
          plugin = echodoc;
          config = ''
            let g:echodoc#enable_at_startup = 1
            let g:echodoc#type = 'floating'
            " To use a custom highlight for the float window,
            " change Pmenu to your highlight group
            highlight link EchoDocFloat Pmenu
          '';
        }
        tagbar
        vim-smoothie
        zellij-nvim
      ];
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
