
" reset augroup
augroup LocalAutoCmd
	autocmd!
augroup END

filetype plugin indent on
syntax on

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" lightline
Plug 'itchyny/lightline.vim'
set laststatus=2

" text object plugins
Plug 'sgur/vim-textobj-parameter'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
vnoremap R <Plug>(operator-replace)

Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'editorconfig/editorconfig-vim'

" my settings
Plug 'hidetoshing/tabcommand'
nmap [Prefix]t [Tab]
Plug 'hidetoshing/setEncoding'
Plug 'hidetoshing/setSearch'
Plug 'hidetoshing/setLinenumber'
nmap [Prefix]l [Line]


" Initialize plugin system
call plug#end()

"""""
set t_Co=256

set wildmenu
set showcmd
set shiftwidth=4
set autoindent
set smartindent
set smarttab
set tabstop=4
set expandtab
set nobackup
set autoread
set noswapfile
set nowrap
set backspace=indent,eol,start
set textwidth=0
set tags=~/.tags

" incremant option.
set nf=hex

" increment
nnoremap ++ <C-a>
nnoremap -- <C-x>

" set IME Offset iminsert=0
set imsearch=0
set imdisable

" disable matchparen
let g:loaded_matchparen = 1

""" ----- filetype settings
augroup coding
    autocmd!
    autocmd FileType c,cpp,perl,rb,php,ctp,python set cindent
    autocmd FileType php set ft=php.html
    autocmd FileType smarty set ft=smarty.html
augroup END

" undo setting
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

""" ----- misc
" escape
inoremap <silent> <Esc> <Esc>
inoremap <silent> <C-[> <Esc>

"Prefix-key
nnoremap [Prefix] <nop>
nmap , [Prefix]

" shift + move selection
imap <S-down> <ESC>v
imap <S-up> <ESC>v<up>
imap <S-left> <ESC>v
imap <S-right> <ESC><right>v
vnoremap <S-down> <down>
vnoremap <S-up> <up>
vnoremap <S-left> <left>
vnoremap <S-right> <right>

" move option
nnoremap <silent> g. `.
nnoremap <silent> g0 `.0
nnoremap <silent> gm ``

" auto paren (visual mode)
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

" yank to line end
nmap Y y$<ESC>

" reload .vimrc
nnoremap [Prefix]vr  :<C-u>source $MYVIMRC<Return>
command! -nargs=0 ReloadSetting :<C-u>source $MYVIMRC<Return>
nnoremap [Prefix]vv  :<C-u>e $MYVIMRC<Return>

""" unite prefix key

" Open Scratch
command! -nargs=0 ScratchOpen :tabnew<CR>e ~/.scratch.howm

" temp extention file
command! -nargs=1 -complete=filetype Temp tabe ~/.scratch.<args>

set clipboard+=unnamed
""" EOF
