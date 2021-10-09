" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable
set t_Co=256

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" install plugins
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'austintaylor/vim-indentobject'
Plug 'christoomey/vim-tmux-navigator'
Plug 'juvenn/mustache.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'garbas/vim-snipmate'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nono/vim-handlebars'
Plug 'scrooloose/nerdtree'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-pastie'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vividchalk'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/greplace.vim'
Plug 'vim-scripts/matchit.zip'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'fatih/vim-go'
Plug 'tomasiser/vim-code-dark'
Plug 'shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/syntastic'
Plug 'vim-syntastic/syntastic'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'tsandall/vim-rego'
Plug 'Chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'vim-airline/vim-airline'
call plug#end()

filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamedplus                                    " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:.
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set textwidth=80
set encoding=UTF-8
" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" leader
let mapleader = ','

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1

if executable('rg')
  " Use rg over Grep
  set grepprg=rg\ --vimgrep
  " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Don't cut with d
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d

set autowrite
set nocursorline
set nowritebackup
set whichwrap+=<,>,h,l,[,] " Wrap arrow keys between lines

" VSCode color scheme
set background=dark
colorscheme codedark

" Overwrite the tab color set by codedark to be a less distracting grey
highlight SpecialKey ctermfg=8

" Map Ctrl+n to nerd tree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

let g:deoplete#enable_at_startup = 1

" go autocomplete
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1
let g:go_diagnostics_level = 2
au filetype go inoremap <buffer> . .<C-x><C-o>

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"" terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 0

call deoplete#custom#option('omni_patterns', {
\ 'complete_method': 'omnifunc',
\ 'terraform': '[^ *\t"{=$]\w*',
\})

"" opa
let g:formatdef_rego = '"opa fmt | sed -e \"s|\t|  |g\""'
let g:formatters_rego = ['rego']
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_verbosemode = 1
au BufWritePre *.rego Autoformat

"" prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

"" markdown preview
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_github=1

let g:snipMate = { 'snippet_version' : 1 }

set colorcolumn=80
