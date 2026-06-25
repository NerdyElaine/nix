{
  config,
  pkgs,
  ...
}:
let
  flatwhite-vim = pkgs.vimUtils.buildVimPlugin {
    name = "flatwhite-vim";
    src = pkgs.fetchFromGitHub {
      owner = "kamwitsta";
      repo  = "flatwhite-vim";
      rev   = "master";
      sha256 = "sha256-WVKp8OROOGwGghM0L/M+e47KTTQcJKDnQynTg+fxIBM";
    };
  };
in
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      ale
      asyncomplete-lsp-vim
      asyncomplete-vim
      fzf-vim
      vim-fugitive
      vim-gitgutter
      vim-polyglot
      vim-airline
      vim-airline-themes
      flatwhite-vim
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      set mapleader = " "
      set number
      set relativenumber
      filetype plugin indent on
      set expandtab
      set shiftwidth=4
      set signcolumn=yes
      set softtabstop=4
      set tabstop=4
      set nowrap
      set smartindent 
      set noswapfile
      set scrolloff=8 
      syntax enable

      if has('termguicolors')
                set termguicolors
      endif
      colorscheme flatwhite

       let g:ale_completion_enabled = 0   " use asyncomplete instead
      let g:ale_sign_error = '✘'
      let g:ale_sign_warning = '▲'
      let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
      let g:ale_fix_on_save = 1

      " Key mappings
      nmap <silent> [d <Plug>(ale_previous_wrap)
      nmap <silent> ]d <Plug>(ale_next_wrap)
      nmap <silent> <leader>ca <Plug>(ale_code_action)
      nmap <silent> <leader>cr <Plug>(ale_rename)
      nmap <silent> gd <Plug>(ale_go_to_definition)
      nmap <silent> gr <Plug>(ale_find_references)
      nmap <silent> K  <Plug>(ale_hover)

      " Configure per-language LSP servers
      let g:ale_linters = {
        \ 'nix':        ['nixd'],
        \ 'python':     ['basedpyright'],
        \ 'typescript': ['tsserver'],
        \ 'javascript': ['tsserver'],
        \ 'rust':       ['analyzer'],
        \ }

      let g:ale_fixers = {
        \ '*':          ['remove_trailing_lines', 'trim_whitespace'],
        \ 'nix':        ['nixfmt'],
        \ 'python':     ['black', 'isort'],
        \ 'typescript': ['prettier'],
        \ 'javascript': ['prettier'],
        \ 'rust':       ['rustfmt'],
        \ }

       let g:ale_completion_enabled = 0   " use asyncomplete instead
      let g:ale_sign_error = '✘'
      let g:ale_sign_warning = '▲'
      let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
      let g:ale_fix_on_save = 1

      " Key mappings
      nmap <silent> [d <Plug>(ale_previous_wrap)
      nmap <silent> ]d <Plug>(ale_next_wrap)
      nmap <silent> <leader>ca <Plug>(ale_code_action)
      nmap <silent> <leader>cr <Plug>(ale_rename)
      nmap <silent> gd <Plug>(ale_go_to_definition)
      nmap <silent> gr <Plug>(ale_find_references)
      nmap <silent> K  <Plug>(ale_hover)


      " Colemak bindings
      noremap m h
      noremap n j
      noremap e k
      noremap i l
      nnoremap <C-d> <C-d>zz
      nnoremap <C-l> <C-u>zz

      nnoremap <silent> <C-m> :<C-U>TmuxNavigateLeft<cr>
      nnoremap <silent> <C-n> :<C-U>TmuxNavigateDown<cr>
      nnoremap <silent> <C-e> :<C-U>TmuxNavigateUp<cr>
      nnoremap <silent> <C-i> :<C-U>TmuxNavigateRight<cr>

      " Tab to select completion
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
      inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"
      set completeopt=menuone,noinsert,noselect
      set shortmess+=c

      noremap k nzzzv
      noremap K Nzzzv
      noremap u i
      noremap l u
      noremap f e
      nnoremap cu ci
      nnoremap vu vi
      nnoremap du di

      " Move lines up/down
      nnoremap <A-j> :m .+1<CR>==
      nnoremap <A-k> :m .-2<CR>==
      vnoremap <A-j> :m '>+1<CR>gv=gv
      vnoremap <A-k> :m '<-2<CR>gv=gv

      let g:gitgutter_sign_added    = '▎'
      let g:gitgutter_sign_modified = '▎'
      let g:gitgutter_sign_removed  = '▾'
      nmap <leader>hp <Plug>(GitGutterPreviewHunk)
      nmap <leader>hs <Plug>(GitGutterStageHunk)
      nmap <leader>hu <Plug>(GitGutterUndoHunk)
      nmap ]h <Plug>(GitGutterNextHunk)
      nmap [h <Plug>(GitGutterPrevHunk)

      " FUGITIVE
      nnoremap <leader>gs :Git<CR>
      nnoremap <leader>gb :Git blame<CR>
      nnoremap <leader>gd :Gdiffsplit<CR>
      nnoremap <leader>gl :Git log --oneline<CR>
      nnoremap <leader>gp :Git push<CR>


      " Keybindings
      nnoremap <leader>o :so<CR>
      nnoremap <leader>e :Files<CR>
      nnoremap <leader>fo :History<CR>
      nnoremap <leader>fb :Buffers<CR>
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap ; :

    '';
  };
}
