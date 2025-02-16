{pkgs ? import <nixpkgs> {}}: {
  plugins = with pkgs.vimPlugins; [
    neoscroll-nvim
    vim-fugitive
    {
      plugin = lightline-vim;
      config = ''
        let g:lightline = {
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
  ];
  config = ''
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
    " Copy indent from current line when starting a new line.
    set autoindent
    " Turn case sensitive search off and smartcase search on
    set ignorecase
    set smartcase
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
}
