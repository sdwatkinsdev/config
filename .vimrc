if has("gui_running")
    colorscheme torte
else
    colorscheme zellner
endif

set ignorecase smartcase
set incsearch
set number
set wildmenu
set showmatch
set scrolloff=5
set history=1000
set undolevels=1000
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
syntax on

" line and column info in statusline
set ruler

" fix Esc delay issue in MacVim
set timeoutlen=1000 ttimeoutlen=0

" probably this won't work
set diffopt+=iwhite

" Clipboard/register compatibility
set clipboard=unnamed

" Persistent undo history between sessions
set undofile
set undodir=~/.vim/undodir

" Enable filetype-specific plugins like matchit
filetype plugin on
runtime macros/matchit.vim

let mapleader=","

" don't have to SHIFT for every command
nnoremap ; :
vnoremap ; :

" edit and source ~/.vimrc
nnoremap <leader>ev :vsp ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>
nnoremap <leader>b :ls<CR>:b<Space>

" better paren nav
nnoremap ( ?(<CR>
nnoremap ) /)<CR>
nnoremap { ?{<CR>
nnoremap } /}<CR>
nnoremap [ ?[<CR>
nnoremap ] /]<CR>
nnoremap - f_l
nnoremap _ hF_l

vnoremap ( ?(<CR>
vnoremap ) /)<CR>
vnoremap { ?{<CR>
vnoremap } /}<CR>
vnoremap [ ?
vnoremap ] /]<CR>

" make Y work like C and D
nnoremap Y y$

" add space before
nnoremap <SPACE> i <ESC>

" paste over word
nnoremap <leader>p viw"0p

" select all
nnoremap <leader>a ggVG

" add comment
nnoremap <leader>/ ^i# <ESC>b

" Regenerate tags for Ruby projects (works in real Vim but not IdeaVim)
nnoremap <leader>gt :!ripper-tags -R --exclude=vendor<CR>

" add and remove parens/braces
" TODO USE vim-surround INSTEAD
" nnoremap <leader>bd /)<CR>x?(<CR>x
" DOESN'T WORK IN RUBYMINE AND `> INCONSISTENT WITH MACVIM
" vnoremap <leader>ba <Esc>`>a)<Esc>`<i(<Esc>

" color stuff that needs to go elsewhere
highlight Error ctermbg=124
highlight ErrorMsg ctermbg=124
highlight SpellBad ctermbg=124
hi ALEWarning ctermbg=black

" not sure if these work; needs custom setting
hi DiffAdd ctermbg=40
hi DiffChange ctermbg=8
hi DiffDelete ctermbg=124
hi DiffText ctermbg=22 ctermfg=15

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
" I liked gitgutter, but it clashes with ALE, which I like slightly more
" Plug 'airblade/vim-gitgutter'

" Initialize plugin system
call plug#end()

" CtrlP settings (fuzzy file/buffer locator)
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_open_multiple_files = '1vj'

nnoremap <leader>cp :CtrlPBuffer<cr>

" ALE shortcuts for prev/next error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

function! StandardizeTargetSchemaJson()
    g/^\s*$/d
    %s/\[\n\s*\]/[]/e
    g/\[\]/d
    g/"required": false/d
    g/"classifier": false/d
    g/"hidden": false/d
    g/"read_only": false/d
    g/description": null/d
    %s/,\(\n\s*}\)/\1/e
    %s/:\([^ ]\)/: \1/e

    " clean up html descriptions
    %s/_x000[ad]_/\\n/ge
    %s/>[ n\\]\+</></ge
endfunction
