{ pkgs, ... }: {
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
    coreutils
    curl
    eza
    fzf
    gh
    jq
    mosh
    nixfmt
    nodejs-slim
    openssl
    picocom
    pre-commit
    python311
    python311Packages.ipython
    #qmk
    #usbutils
    ripgrep
    rustup
    rsync
    zoxide
  ];

  xdg.configFile."zed/settings.json".text = ''
    {
      "telemetry": {
        "metrics": false
      },
      "theme": "Rosé Pine",
      "buffer_font_size": 13,
      "buffer_font_family": "Berkeley Mono",
      "vim_mode": true,
      "relative_line_numbers": true,
      "soft_wrap": "preferred_line_length"
    }
  '';

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Solarized (dark)";
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
        map-syntax = [ ".ignore:Git Ignore" "h:cpp" ];
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
        merge.conflictstyle = "diff3";
        push.default = "tracking";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        rerere.enabled = 1;
        submodule.recurse = true;
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
          side-by-side = true;
        };
      };
      lfs = { enable = true; };
    };
    fish = {
      enable = true;
      plugins = with pkgs; [
        {
          name = "hydro";
          src = fishPlugins.hydro.src;
        }
        {
          name = "plugin-git";
          src = fishPlugins.plugin-git.src;
        }
        {
          name = "sponge";
          src = fishPlugins.sponge.src;
        }
        {
          name = "foreign-env";
          src = fishPlugins.foreign-env.src;
        }
        {
          name = "nix-fish";
          src = fetchFromGitHub {
            owner = "kidonng";
            repo = "nix.fish";
            rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
            hash = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
          };
        }
      ];
      shellAliases = { rm = "rm -i"; };
      shellAbbrs = { ec = "emacsclient -t"; };
      loginShellInit = "zoxide init fish | source";
    };
    tmux = {
      enable = true;
      mouse = true;
      terminal = "xterm-256color";
      shortcut = "a";
      newSession = true;
      keyMode = "vi";
      secureSocket = false;
      sensibleOnTop = true;
      plugins = with pkgs; [
        tmuxPlugins.copycat
        tmuxPlugins.yank
        tmuxPlugins.sessionist
        {
          plugin = tmuxPlugins.tmux-colors-solarized;
          extraConfig = ''
            set -g @colors-solarized 'dark'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
      extraConfig = ''
        # switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D
      '';
    };
    kitty = {
      enable = true;
      theme = "Solarized Dark - Patched";
      font = {
        name = "Berkeley Mono";
        size = 13;
      };
      keybindings = { "super+v" = "paste_from_clipboard"; };
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
                  \ 'colorscheme': 'wombat',
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
      ];
    };
  };
}
