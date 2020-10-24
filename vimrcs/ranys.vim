set clipboard=unnamed
set wrap linebreak nolist
set number relativenumber
set autoindent
set paste
set scrolloff=0

" Space indentation
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab


" Gruvbox
autocmd vimenter * colorscheme gruvbox
colorscheme gruvbox
" color ir_black
" color solarized
" color pyte

nnoremap <esc><esc> :nohls<cr>

" VimDiff word wrap
au VimEnter * if &diff | execute 'windo set wrap' | endif

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

let g:airline_powerline_fonts = 1

" CtrlP Plugin - http://ctrlpvim.github.io/ctrlp.vim/
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

